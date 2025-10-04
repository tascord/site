import { H3Event } from "h3";
import { Filter } from "content-checker";
import { JSONFilePreset } from "lowdb/node";

const runtime = useRuntimeConfig();
const filter = new Filter({ openModeratorAPIKey: runtime.OPENMOD_KEY });
const db = await JSONFilePreset('guestbook.json', { posts: [] as Entry[] })
export type Entry = { author?: string, content: string, timestamp: number };

export default defineEventHandler(event => {
    if (event.method == 'GET') return get_posts(event);
    else if (event.method == 'PUT') return write_post(event);
    else if (event.method == 'DELETE') return delete_post(event);
    else if (event.method == 'OPTIONS') return get_count(event);
    else {
        const err = createError('Expected GET/PUT/DELETE');
        err.statusCode = 405;
        return sendError(event, err);
    }
});

async function get_count(_event: H3Event) {
    return db.data.posts.length;
}

async function get_posts(event: H3Event) {
    const query = getQuery(event);
    const index = Number(query.index) || 0;
    const count = Number(query.count) || 20;
    if (count > 50) {
        const err = createError('Count too large');
        err.statusCode = 400;
        return sendError(event, err);
    }
    const posts = db.data.posts.slice(index, index + count);
    return posts;
}

async function write_post(event: H3Event) {
    const body = await readBody(event);
    if (!body || !body.content || String(body.content).length < 2 || String(body.content).length > 300) {
        const err = createError('Malformed body (needs content between two and eight hundred characters)');
        err.statusCode = 400;
        return sendError(event, err);
    }

    const author = body.author ?? undefined;

    // Moderate content before saving
    const profane = (await filter.isProfaneAI(body.content)).profane;
    if (profane) {
        const err = createError('Content probably not appropriate');
        err.statusCode = 400;
        return sendError(event, err);
    }

    // Add to database
    const entry: Entry = { author, content: body.content, timestamp: Date.now() };
    db.data.posts.push(entry);
    await db.write();
    return { success: true, entry };
}

async function delete_post(event: H3Event) {
    const query = getQuery(event);
    const index = Number(query.index);
    const secret = query.auth;

    if (secret !== runtime.GUESTBOOK_MOD_SECRET) {
        const err = createError('Unauthorized');
        err.statusCode = 403;
        return sendError(event, err);
    }

    if (isNaN(index) || index < 0 || index >= db.data.posts.length) {
        const err = createError('Invalid index');
        err.statusCode = 400;
        return sendError(event, err);
    }

    db.data.posts.splice(index, 1);
    await db.write();
    return { success: true };
}
