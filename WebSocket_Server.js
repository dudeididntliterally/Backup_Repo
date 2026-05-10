// You need a VPS to use this system and to set it up properly.
// You can use Kamatera, which is entirely free to use to set up this system.
// Then use Firebase Firestore to use the coins system.
// Also create a file named .env in your VPS root folder.
require('dotenv').config()
const WebSocket = require("ws")
const wss = new WebSocket.Server({ port: 80 })
const rooms = {}
const http = require("http")
const https = require("https")
const global_users = new Map()
const fs = require("fs")
const PERSIST_FILE = "./persistent_users.json"
const OUTFITS_FILE = "./attributes/user_outfits_data.json"
const FIREBASE_PROJECT = "user-outfits-main"
const FIREBASE_KEY = process.env.FIREBASE_KEY
const FIREBASE_KEY_TWO = process.env.FIREBASE_TWO_KEY
const FIREBASE_KEY_COINS = process.env.FIREBASE_TWO_KEY
const FIREBASE_PROJECT_COINS = "user-coins-main"
const MainURLs = {
    warn: process.env.WEBHOOK_WARN,
    alert: process.env.WEBHOOK_ALERT,
    warnings: process.env.WEBHOOK_WARNINGS,
    issues: process.env.WEBHOOK_ISSUES,
    warns: process.env.WEBHOOK_WARNS,
    feedback: process.env.WEBHOOK_FEEDBACK,
    axerchat: process.env.WEBHOOK_AXERCHAT
}

function firestore_save_coins(username, coins, callback) {
    const body = JSON.stringify({ fields: { coins: { doubleValue: coins } } })
    const path = `/v1/projects/${FIREBASE_PROJECT_COINS}/databases/(default)/documents/coins/${username}`
    const req = https.request({
        hostname: "firestore.googleapis.com",
        path: `${path}?key=${FIREBASE_KEY_COINS}`,
        method: "PATCH",
        headers: { "Content-Type": "application/json", "Content-Length": Buffer.byteLength(body) }
    }, res => {
        let raw = ""
        res.on("data", c => raw += c)
        res.on("end", () => {
            console.log(`[COINS/FIREBASE] Save "${username}" -> ${res.statusCode}`)
            if (callback) callback(res.statusCode === 200)
        })
    })
    req.on("error", e => console.log(`[COINS/FIREBASE] Save error: ${e.message}`))
    req.write(body)
    req.end()
}

function firestore_load_coins(username, callback) {
    const path = `/v1/projects/${FIREBASE_PROJECT_COINS}/databases/(default)/documents/coins/${username}`
    https.get({
        hostname: "firestore.googleapis.com",
        path: `${path}?key=${FIREBASE_KEY_COINS}`
    }, res => {
        let raw = ""
        res.on("data", c => raw += c)
        res.on("end", () => {
            if (res.statusCode === 404) { callback(0); return }
            try {
                const parsed = JSON.parse(raw)
                const coins = parsed.fields?.coins?.doubleValue ?? 0
                callback(coins)
            } catch (e) {
                console.log(`[COINS/FIREBASE] Load error: ${e.message}`)
                callback(0)
            }
        })
    }).on("error", () => callback(0))
}

firestore_load_coins(ws.username, (coins) => {
    if (!coins_data[ws.username]) {
        coins_data[ws.username] = { coins }
        console.log(`[COINS] Restored "${ws.username}" -> ${coins} coins from Firebase`)
    }
})

function load_outfits_data() {
    try {
        if (fs.existsSync(OUTFITS_FILE)) {
            const raw = fs.readFileSync(OUTFITS_FILE, "utf8")
            return JSON.parse(raw)
        }
    } catch (e) {
        console.log(`[OUTFITS]: Failed to load: ${e.message}`)
    }
    return {}
}

function save_outfits_data(data) {
    try {
        fs.writeFileSync(OUTFITS_FILE, JSON.stringify(data, null, 2))
    } catch (e) {
        console.log(`[OUTFITS] Failed to save: ${e.message}`)
    }
}

const outfits_data = load_outfits_data()
console.log(`[OUTFITS] Loaded outfit data for ${Object.keys(outfits_data).length} user(s)`)

function to_firestore_value(val) {
    if (typeof val === "string") return { stringValue: val }
    if (typeof val === "number") return { doubleValue: val }
    if (typeof val === "boolean") return { booleanValue: val }
    if (Array.isArray(val)) return { arrayValue: { values: val.map(to_firestore_value) } }
    if (typeof val === "object" && val !== null) {
        const fields = {}
        for (const [k, v] of Object.entries(val)) fields[k] = to_firestore_value(v)
        return { mapValue: { fields } }
    }
    return { nullValue: null }
}

function from_firestore_value(val) {
    if (val.stringValue !== undefined) return val.stringValue
    if (val.doubleValue !== undefined) return val.doubleValue
    if (val.integerValue !== undefined) return Number(val.integerValue)
    if (val.booleanValue !== undefined) return val.booleanValue
    if (val.nullValue !== undefined) return null
    if (val.arrayValue) return (val.arrayValue.values || []).map(from_firestore_value)
    if (val.mapValue) {
        const out = {}
        for (const [k, v] of Object.entries(val.mapValue.fields || {})) out[k] = from_firestore_value(v)
        return out
    }
    return null
}

function firestore_save(collection, document, data, callback) {
    const fields = {}
    for (const [k, v] of Object.entries(data)) fields[k] = to_firestore_value(v)

    const body = JSON.stringify({ fields })
    const path = `/v1/projects/${FIREBASE_PROJECT}/databases/(default)/documents/${collection}/${document}`
    const req = https.request({
        hostname: "firestore.googleapis.com",
        path: `${path}?key=${FIREBASE_KEY}`,
        method: "PATCH",
        headers: {
            "Content-Type": "application/json",
            "Content-Length": Buffer.byteLength(body)
        }
    }, res => {
        let raw = ""
        res.on("data", c => raw += c)
        res.on("end", () => {
            console.log(`[FIREBASE] Save "${collection}/${document}" -> ${res.statusCode}`)
            if (callback) callback(res.statusCode === 200)
        })
    })
    req.on("error", e => console.log(`[FIREBASE] Save error: ${e.message}`))
    req.write(body)
    req.end()
}

function firestore_load(collection, document, callback) {
    const path = `/v1/projects/${FIREBASE_PROJECT}/databases/(default)/documents/${collection}/${document}`
    
    https.get({
        hostname: "firestore.googleapis.com",
        path: `${path}?key=${FIREBASE_KEY}`
    }, res => {
        let raw = ""
        res.on("data", c => raw += c)
        res.on("end", () => {
            if (res.statusCode === 404) {
                callback(null)
                return
            }
            try {
                const parsed = JSON.parse(raw)
                if (!parsed.fields) { callback(null); return }
                const out = {}
                for (const [k, v] of Object.entries(parsed.fields)) {
                    out[k] = from_firestore_value(v)
                }
                callback(out)
            } catch (e) {
                console.log(`[FIREBASE] Load parse error: ${e.message}`)
                callback(null)
            }
        })
    }).on("error", e => {
        console.log(`[FIREBASE] Load error: ${e.message}`)
        callback(null)
    })
}

function load_persistent_users() {
    try {
        if (fs.existsSync(PERSIST_FILE)) {
            const raw = fs.readFileSync(PERSIST_FILE, "utf8")
            return JSON.parse(raw)
        }
    } catch (e) {
        console.log(`[PERSIST] Failed to load: ${e.message}`)
    }
    return {}
}

function save_persistent_users() {
    try {
        fs.writeFileSync(PERSIST_FILE, JSON.stringify(persistent_users, null, 2))
    } catch (e) {
        console.log(`[PERSIST] Failed to save: ${e.message}`)
    }
}

const persistent_users = load_persistent_users()
console.log(`[PERSIST]: Loaded ${Object.keys(persistent_users).length} persistent user(s)`)

function register_persistent_user(username) {
    if (!persistent_users[username]) {
        persistent_users[username] = {
            username: username,
            first_seen: Date.now(),
            last_seen: Date.now(),
            banned: false,
            trusted: false,
            notes: ""
        }
        console.log(`[PERSIST] Registered new user: "${username}"`)
    } else {
        persistent_users[username].last_seen = Date.now()
        console.log(`[PERSIST] Updated last_seen for: "${username}"`)
    }
    save_persistent_users()
}

function remove_persistent_user(username) {
    if (persistent_users[username]) {
        delete persistent_users[username]
        save_persistent_users()
        console.log(`[PERSIST] Removed user: "${username}"`)
        return true
    }
    return false
}

function is_user_banned(username) {
    return persistent_users[username]?.banned === true
}

function post_link(hookName, payload) {
    const url = MainURLs[hookName]
    if (!url) {
        console.log(`[LINK] Unknown hook: "${hookName}"`)
        return
    }

    let body
    if (payload.embed) {
        body = JSON.stringify(payload.embed)
    } else {
        body = JSON.stringify({ content: payload.text || "" })
    }

    const u = new URL(url)
    const req = https.request({
        hostname: u.hostname,
        path: u.pathname + "?wait=true",
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "Content-Length": Buffer.byteLength(body)
        }
    }, res => {
        let raw = ""
        res.on("data", chunk => raw += chunk)
        res.on("end", () => console.log(`[LINK] "${hookName}" -> ${res.statusCode} | ${raw}`))
    })

    req.on("error", e => console.log(`[LINK] "${hookName}" error: ${e.message}`))
    req.write(body)
    req.end()
}

function get_room(id) {
    if (!rooms[id]) {
        rooms[id] = {
            clients: new Set(),
            users: new Map(),
            history: [],
            seen_users: new Set()
        }
        console.log(`[ROOM] Created room: "${id}"`)
    }
    return rooms[id]
}

function cleanup_room(id) {
    if (rooms[id] && rooms[id].clients.size === 0) {
        console.log(`[ROOM] Deleted empty room: "${id}"`)
        delete rooms[id]
    }
}

function broadcast(room, payload, room_id) {
    const msg = JSON.stringify(payload)
    let sent = 0
    room.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(msg)
            sent++
        }
    })
    console.log(`[BROADCAST] room="${room_id}" clients=${room.clients.size} sent=${sent} payload=${msg}`)
}

function broadcast_all(payload) {
    const msg = JSON.stringify(payload)
    let sent = 0
    Object.entries(rooms).forEach(([room_id, room]) => {
        room.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(msg)
                sent++
            }
        })
    })
    console.log(`[ANNOUNCE] Sent to ${sent} client(s) across ${Object.keys(rooms).length} room(s): ${msg}`)
}

wss.on("connection", (ws) => {
    ws.server_id = null
    ws.username = null
    ws.last_msg_time = 0

    ws.send(JSON.stringify({ type: "hello" }))
    console.log(`[CONNECT]: New connection. Total rooms: ${Object.keys(rooms).length}`)

    ws.on("message", (raw) => {
        let data
        try {
            data = JSON.parse(raw)
        } catch {
            console.log(`[ERROR]: Failed to parse: ${raw}`)
            return
        }

        if (!data || typeof data.type !== "string") return
        if (data.type !== "get_list") {
            console.log(`[MSG] type="${data.type}" user="${data.user || data.from || ws.username || "?"}" server="${data.server || ws.server_id || "?"}"`)
        }

        if (!ws.authenticated && data.type !== "auth") {
            ws.send(JSON.stringify({ type: "error", reason: "Not authenticated" }))
            ws.terminate()
            return
        }
        if (data.type === "auth") {
            if (data.token === process.env.CLIENT_TOKEN) {
                ws.authenticated = true
                ws.auth_user = data.user
                ws.send(JSON.stringify({ type: "auth_ok" }))
            } else {
                ws.terminate()
            }
            return
        }

        if (data.type === "join" || data.type === "rejoin") {
            if (typeof data.server !== "string" || typeof data.user !== "string") {
                console.log(`[JOIN] Rejected — missing server or user`)
                return
            }

            const room = get_room(data.server)

            if (room.users.has(data.user) && room.users.get(data.user) !== ws) {
                const stale = room.users.get(data.user)
                console.log(`[JOIN] Evicting stale room connection for "${data.user}"`)
                room.clients.delete(stale)
                room.users.delete(data.user)
                try { stale.terminate() } catch (_) {}
            }

            if (global_users.has(data.user) && global_users.get(data.user) !== ws) {
                const stale = global_users.get(data.user)
                console.log(`[JOIN] Evicting stale global connection for "${data.user}"`)
                global_users.delete(data.user)
                try { stale.terminate() } catch (_) {}
            }

            ws.server_id = data.server
            ws.username = data.user

            room.clients.add(ws)
            room.users.set(ws.username, ws)
            global_users.set(ws.username, ws)

            const isRejoin = data.type === "rejoin" || room.seen_users.has(ws.username)
            room.seen_users.add(ws.username)
            const joinText = isRejoin ? ws.username + " rejoined" : ws.username + " joined"

            if (!outfits_data[ws.username]) {
                firestore_load("outfits", ws.username, (firebaseData) => {
                    if (firebaseData) {
                        outfits_data[ws.username] = firebaseData
                        save_outfits_data(outfits_data)
                        console.log(`[OUTFITS] Restored "${ws.username}" outfits from Firebase`)
                        if (ws.readyState === WebSocket.OPEN) {
                            ws.send(JSON.stringify({
                                type: "outfit_list_result",
                                success: true,
                                outfits: firebaseData,
                                source: "firebase_restore"
                            }))
                        }
                    }
                })
            }

            console.log(`[JOIN] "${ws.username}" ${isRejoin ? "re" : ""}joined room "${ws.server_id}" — room now has ${room.clients.size} client(s)`)
            broadcast(room, { system: true, text: joinText }, ws.server_id)

            room.history.forEach(m => {
                if (ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify(m))
            })

        } else if (data.type === "leave") {
            if (!ws.server_id) return
            const room = rooms[ws.server_id]
            if (!room) return

            room.clients.delete(ws)
            if (ws.username) {
                room.users.delete(ws.username)
                global_users.delete(ws.username)
            }

            console.log(`[LEAVE] "${ws.username}" left room "${ws.server_id}" — room now has ${room.clients.size} client(s)`)
            broadcast(room, { system: true, text: (ws.username || "unknown") + " left" }, ws.server_id)
            cleanup_room(ws.server_id)

        } else if (data.type === "message") {
            if (typeof data.text !== "string" || typeof data.user !== "string") {
                console.log(`[MSG] Dropped — missing text or user`)
                return
            }
            if (data.text.length === 0 || data.text.length > 200) {
                console.log(`[MSG] Dropped — text length ${data.text.length}`)
                return
            }
            if (!ws.server_id) {
                console.log(`[MSG] Dropped — ws has no server_id (never joined?)`)
                return
            }

            const now = Date.now()
            if (now - ws.last_msg_time < 500) {
                console.log(`[MSG] Dropped — rate limited`)
                return
            }
            ws.last_msg_time = now

            const room = rooms[ws.server_id]
            if (!room) {
                console.log(`[MSG] Dropped — room "${ws.server_id}" not found`)
                return
            }

            const payload = { user: data.user, text: data.text }
            room.history.push(payload)
            if (room.history.length > 10) room.history.shift()

            broadcast(room, payload, ws.server_id)

        } else if (data.type === "pm") {
            if (!ws.server_id) return
            if (typeof data.to !== "string" || typeof data.text !== "string") return

            const room = rooms[ws.server_id]
            if (!room) return

            const target = room.users.get(data.to)
            if (!target) {
                console.log(`[PM] Target "${data.to}" not found in room`)
                return
            }

            const payload = { type: "pm", from: ws.username, to: data.to, text: data.text }
            if (target.readyState === WebSocket.OPEN) target.send(JSON.stringify(payload))
            if (ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify(payload))

        } else if (data.type === "typing") {
            if (!ws.server_id) return
            const room = rooms[ws.server_id]
            if (!room) return

            room.clients.forEach(client => {
                if (client !== ws && client.readyState === WebSocket.OPEN) {
                    client.send(JSON.stringify({ type: "typing", user: data.user, state: data.state }))
                }
            })

        } else if (data.type === "announce") {
            if (data.secret !== process.env.ADMIN_SECRET) {
                console.log(`[ANNOUNCE]: Rejected — wrong or missing secret`)
                return
            }
            if (typeof data.text !== "string" || data.text.length === 0 || data.text.length > 200) {
                console.log(`[ANNOUNCE]: Dropped — invalid text`)
                return
            }

            const display_time = (typeof data.display_time === "number" && data.display_time > 0)
                ? data.display_time
                : 5

            broadcast_all({
                type: "announce",
                text: data.text,
                display_time: display_time
            })

        } else if (data.type === "post") {
            if (typeof data.hook !== "string") return
            if (!ws.server_id) return

            console.log(`[LINK] "${ws.username}" -> hook="${data.hook}"`)
            post_link(data.hook, {
                user: ws.username || "unknown",
                text: data.text || "",
                embed: data.embed || null
            })

        } else if (data.type === "anti_stealer_state") {
            if (data.secret !== process.env.ADMIN_SECRET) {
                console.log(`[ANTI_STEALER]: Rejected — wrong secret`)
                return
            }

            const target = data.user
            if (!target) return

            if (!persistent_users[target]) {
                register_persistent_user(target)
            }

            persistent_users[target].anti_stealer = data.state === true
            persistent_users[target].last_seen = Date.now()
            save_persistent_users()

            console.log(`[ANTI_STEALER] "${target}" -> ${data.state}`)
            ws.send(JSON.stringify({ type: "anti_stealer_ack", user: target, state: data.state }))

        } else if (data.type === "check_anti_stealer") {
            const target = data.target
            if (!target) return
            const state = persistent_users[target]?.anti_stealer === true
            ws.send(JSON.stringify({
                type: "anti_stealer_check_result",
                target: target,
                protected: state
            }))

            console.log(`[ANTI_STEALER]: Check for: "${target}" -> ${state}`)

        } else if (data.type === "get_script") {
            fs.readFile("./server.lua", "utf8", (err, content) => {
                if (err) {
                    ws.send(JSON.stringify({ type: "script_response", error: "Not found" }))
                    return
                }
    
                const escaped = content.replace(/[\u{10000}-\u{10FFFF}]/gu, (char) => {
                    const codePoint = char.codePointAt(0).toString(16).toUpperCase()
                    return `\\u{${codePoint}}`
                })

                const encoded = Buffer.from(escaped, "utf8").toString("base64")

                ws.send(JSON.stringify({
                    type: "script_response",
                    content: encoded,
                    encoded: true
                }))
            })

        } else if (data.type === "get_list") {
            fs.readFile("./attributes/list.json", "utf8", (err, content) => {
                if (err) {
                    ws.send(JSON.stringify({ type: "list_response", error: "Not found" }))
                    return
                }

                let parsed
                try {
                    parsed = JSON.parse(content)
                    ws.send(JSON.stringify({ type: "list_response", content: parsed }))
                } catch (e) {
                    ws.send(JSON.stringify({ type: "list_response", content: content }))
                }
            })

        } else if (data.type === "run_directories") {
            fs.readFile("./Directories/WebSocket_Functionality.lua", (err, content) => {
                if (err) {
                    ws.send(JSON.stringify({ type: "directories_file", error: "Not found" }))
                    return
                }

                const encoded = Buffer.from(content).toString("base64")

                ws.send(JSON.stringify({
                    type: "directories_file",
                    content: encoded,
                    encoded: true
                }))
            })

        } else if (data.type === "player_action") {
            if (data.secret !== process.env.STAFF_SECRET) {
                console.log(`[ACTION] Rejected — wrong secret`)
                return
            }

            const action = data.action
            const target = data.target
            if (!action || !target) return
            const targetWs = global_users.get(target)
            if (!targetWs || targetWs.readyState !== WebSocket.OPEN) {
                ws.send(JSON.stringify({ type: "action_result", success: false, reason: "User not found or offline", target }))
                return
            }

            if (action === "kick") {
                targetWs.send(JSON.stringify({ type: "kicked", reason: data.reason || "Kicked by admin" }))
                setTimeout(() => targetWs.terminate(), 500)

                const room = rooms[targetWs.server_id]
                if (room) {
                    room.clients.delete(targetWs)
                    room.users.delete(target)
                    broadcast(room, { system: true, text: target + " was kicked" }, targetWs.server_id)
                    cleanup_room(targetWs.server_id)
                }
                global_users.delete(target)

                ws.send(JSON.stringify({ type: "action_result", success: true, action, target }))
                console.log(`[ACTION] Kicked "${target}"`)

            } else if (action === "bring" || action === "kill") {
                targetWs.send(JSON.stringify({
                    type: "player_action",
                    action: action,
                    from: ws.username || "admin",
                    ...(data.position && { position: data.position })
                }))

                ws.send(JSON.stringify({ type: "action_result", success: true, action, target }))
                console.log(`[ACTION]: "${action}" sent to: "${target}"`)
            } else {
                ws.send(JSON.stringify({ type: "action_result", success: false, reason: "Unknown action", target }))
            }
        
        } else if (data.type === "avatar_copy_attempt") {
            const targetName = data.target
            if (!targetName || typeof targetName !== "string") return

            const targetWs = global_users.get(targetName)
            if (!targetWs || targetWs.readyState !== WebSocket.OPEN) {
                console.log(`[AVATAR_COPY] Target "${targetName}" not online`)
                return
            }

            targetWs.send(JSON.stringify({
                type: "avatar_copy_warning",
                from: ws.username || "unknown",
                server: ws.server_id || "unknown"
            }))

            console.log(`[AVATAR_COPY] "${ws.username}" attempted to copy "${targetName}"`)
        
        } else if (data.type === "outfit_save") {
            if (!ws.username || typeof data.name !== "string" || data.name.trim() === "") {
                ws.send(JSON.stringify({ type: "outfit_save_result", success: false, reason: "Missing name or not joined." }))
                return
            }
            if (typeof data.outfit !== "object" || data.outfit === null) {
                ws.send(JSON.stringify({ type: "outfit_save_result", success: false, reason: "Invalid outfit data." }))
                return
            }

            const user = ws.username
            const name = data.name.trim()

            if (!outfits_data[user]) outfits_data[user] = {}
            outfits_data[user][name] = data.outfit
            save_outfits_data(outfits_data)
            firestore_save("outfits", user, outfits_data[user], (ok) => {
                console.log(`[OUTFITS] Outfit sync for: "${user}": ${ok}`)
            })
            console.log(`[OUTFITS] "${user}" saved outfit "${name}"`)
            ws.send(JSON.stringify({ type: "outfit_save_result", success: true, name }))

        } else if (data.type === "outfit_delete") {
            if (!ws.username || typeof data.name !== "string") {
                ws.send(JSON.stringify({ type: "outfit_delete_result", success: false, reason: "Missing name or not joined" }))
                return
            }

            const user = ws.username
            const name = data.name.trim()

            if (outfits_data[user] && outfits_data[user][name]) {
                delete outfits_data[user][name]
                save_outfits_data(outfits_data)
                console.log(`[OUTFITS] "${user}" deleted outfit "${name}"`)
                ws.send(JSON.stringify({ type: "outfit_delete_result", success: true, name }))
            } else {
                ws.send(JSON.stringify({ type: "outfit_delete_result", success: false, reason: "Outfit not found" }))
            }

        } else if (data.type === "outfit_rename") {
            if (!ws.username || typeof data.old_name !== "string" || typeof data.new_name !== "string") {
                ws.send(JSON.stringify({ type: "outfit_rename_result", success: false, reason: "Missing names or not joined" }))
                return
            }

            const user = ws.username
            const old_name = data.old_name.trim()
            const new_name = data.new_name.trim()

            if (!outfits_data[user] || !outfits_data[user][old_name]) {
                ws.send(JSON.stringify({ type: "outfit_rename_result", success: false, reason: "Outfit not found" }))
                return
            }
            if (outfits_data[user][new_name]) {
                ws.send(JSON.stringify({ type: "outfit_rename_result", success: false, reason: "Name already taken" }))
                return
            }

            outfits_data[user][new_name] = outfits_data[user][old_name]
            delete outfits_data[user][old_name]
            save_outfits_data(outfits_data)

            console.log(`[OUTFITS] "${user}" renamed outfit "${old_name}" -> "${new_name}"`)
            ws.send(JSON.stringify({ type: "outfit_rename_result", success: true, old_name, new_name }))

        } else if (data.type === "outfit_list") {
            if (!ws.username) {
                ws.send(JSON.stringify({ type: "outfit_list_result", success: false, reason: "Not joined" }))
                return
            }

            const user = ws.username
            const userOutfits = outfits_data[user] || {}
            const names = Object.keys(userOutfits)

            console.log(`[OUTFITS] "${user}" fetched outfit list (${names.length} outfit(s))`)
            ws.send(JSON.stringify({ type: "outfit_list_result", success: true, outfits: userOutfits }))

        } else if (data.type === "title_join") {
            if (!ws.username || typeof data.title !== "string") return

            const user_title = {
                userid: data.userid,
                name: data.user || ws.username,
                title: data.title,
                color: data.color || [255, 85, 0]
            }

            ws.user_title = user_title
            if (!wss.title_registry) wss.title_registry = new Map()
            wss.title_registry.set(data.userid, user_title)

            const list = Array.from(wss.title_registry.values())
            ws.send(JSON.stringify({ t: "sync", list }))

            wss.clients.forEach(client => {
                if (client !== ws && client.readyState === WebSocket.OPEN) {
                    client.send(JSON.stringify({ t: "add", ...user_title }))
                }
            })

            console.log(`[TITLES] "${ws.username}" joined with title "${data.title}"`)

        } else if (data.type === "title_update") {
            if (!ws.username || typeof data.title !== "string") return
            if (!wss.title_registry) return

            const entry = wss.title_registry.get(data.userid)
            if (entry) {
                entry.title = data.title
                entry.color = data.color || entry.color
                broadcast_all({ t: "update", userid: data.userid, title: data.title, color: entry.color })
                console.log(`[TITLES] "${ws.username}" updated title to "${data.title}"`)
            }

        } else if (data.type === "title_hb") {
            if (wss.title_registry && data.userid) {
                const entry = wss.title_registry.get(data.userid)
                if (entry) entry.last_seen = Date.now()
            }

        } else if (data.type === "get_version") {
            fs.readFile("./attributes/version.json", "utf8", (err, content) => {
                if (err) {
                    ws.send(JSON.stringify({ type: "version_response", error: "Not found" }))
                    return
                }
                try {
                    const parsed = JSON.parse(content)
                    ws.send(JSON.stringify({ type: "version_response", version: parsed.LifeTogether_Admin_Version.trim() }))
                } catch (e) {
                    ws.send(JSON.stringify({ type: "version_response", error: "Parse failed" }))
                }
            })

        // } else if (data.type === "coins_update") {
        //     if (!ws.username) return
        //     const target = typeof data.target === "string" ? data.target : ws.username
        //     const amount = typeof data.amount === "number" ? data.amount : 0
        //     const mode   = data.mode || "add"

        //     if (/^\d+$/.test(target)) {
        //         console.log(`[COINS] Rejected numeric target: "${target}"`)
        //         return
        //     }

        //     if (!coins_data[target]) coins_data[target] = { coins: 0 }
        //     if (mode === "set")           coins_data[target].coins  = amount
        //     else if (mode === "subtract") coins_data[target].coins  = Math.max(0, coins_data[target].coins - amount)
        //     else                          coins_data[target].coins += amount

        //     coins_data[target].last_updated = Date.now()
        //     save_coins_debounced()

        //     broadcast_all({ type: "coins_update", target, coins: coins_data[target].coins })
        //     console.log(`[COINS] "${target}" -> ${coins_data[target].coins} (mode=${mode}, amount=${amount})`)

        // } else if (data.type === "coins_get") {
        //     const target = typeof data.target === "string" ? data.target : ws.username
        //     if (!target) return
        //     if (/^\d+$/.test(target)) return
        //     const coins = coins_data[target]?.coins ?? 0
        //     ws.send(JSON.stringify({ type: "coins_result", target, coins }))
        //     console.log(`[MSG] type="${data.type}" user="${data.user || data.from || ws.username || "?"}" server="${data.server || ws.server_id || "?"}"`)

        // } else if (data.type === "coins_leaderboard") {
        //     const limit = typeof data.limit === "number" ? Math.min(data.limit, 100) : 10
        //     const board = Object.entries(coins_data)
        //         .map(([username, d]) => ({ username, coins: d.coins ?? 0 }))
        //         .filter(entry => entry.coins > 0)
        //         .sort((a, b) => b.coins - a.coins)
        //         .slice(0, limit)
        //     ws.send(JSON.stringify({ type: "coins_leaderboard_result", board }))

        // } else if (data.type === "coins_spend") {
        //     if (!ws.username) return
        //     const target = ws.username
        //     const amount = typeof data.amount === "number" ? data.amount : 0
        //     const item   = typeof data.item === "string" ? data.item : null
        //     if (!item || amount <= 0) return
        //     if (/^\d+$/.test(target)) return
        //     const current = coins_data[target]?.coins ?? 0
        //     if (current < amount) {
        //         ws.send(JSON.stringify({ type: "coins_spend_result", success: false, reason: "insufficient_funds", item }))
        //         return
        //     }
        //     if (!coins_data[target]) coins_data[target] = { coins: 0 }
        //     coins_data[target].coins = current - amount
        //     coins_data[target].last_updated = Date.now()
        //     save_coins_debounced()

        //     broadcast_all({ type: "coins_update", target, coins: coins_data[target].coins })
        //     ws.send(JSON.stringify({ type: "coins_spend_result", success: true, item, remaining: coins_data[target].coins }))
        //     console.log(`[COINS] "${target}" spent ${amount} on "${item}" -> ${coins_data[target].coins} remaining`)
        
        } else if (data.type === "ping") {
            if (ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify({ type: "pong" }))
        }
    })

    ws.on("close", () => {
        if (!ws.server_id) return
        const room = rooms[ws.server_id]
        if (!room) return

        room.clients.delete(ws)
        if (ws.username) {
            room.users.delete(ws.username)
            global_users.delete(ws.username)
        }

        if (ws.user_title && wss.title_registry) {
            wss.title_registry.delete(ws.user_title.userid)
            broadcast_all({ t: "remove", userid: ws.user_title.userid })
            console.log(`[TITLES] Removed title for "${ws.username}" on disconnect`)
        }

        console.log(`[CLOSE] "${ws.username}" disconnected from room "${ws.server_id}" — room now has ${room.clients.size} client(s)`)
        broadcast(room, { system: true, text: (ws.username || "a user") + " disconnected" }, ws.server_id)
        cleanup_room(ws.server_id)
    })
})

console.log("Flames Hub is now online.")
