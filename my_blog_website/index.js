import express from "express";
import sqlite3 from "sqlite3";
import { open } from "sqlite";

const app = express();
const port = 3000;
let db;
(async () =>{
    db = await open({
        filename: './blog.db',
        driver: sqlite3.Database
    });

    await db.exec(`
        CREATE TABLE IF NOT EXISTS posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL);`)
})();

app.use(express.static("public"));
app.use(express.urlencoded({extended: true }));

app.get("/", async (req, res) => {
    const posts = await db.all("SELECT * FROM posts");
    res.render("index.ejs", { posts });
});

app.get("/about", (req, res) =>{
    res.render("about.ejs");
});

app.post("/create-post", async (req, res) =>{
    const { title, content } = req.body;
    if(!title || title.trim().length === 0 || !content || content.trim().length === 0) {
        res.status(400).send("Title and content must not be empty! 😭")
    }else{
        await db.run("INSERT INTO posts (title, content) VALUES (?, ?)", [title, content]);
        res.redirect("/");
    }
});

app.get("/:title", async (req, res) => {
    const postTitle = decodeURIComponent(req.params.title);
    const post = await db.get("SELECT * FROM posts WHERE title = ?", [postTitle]);

    if(post) {
        res.render("post.ejs", { post });
    } else {
        res.status(404).send("Post not found 😵");
    }
});

app.get("/edit/:title", async (req, res) =>{
    const postTitle = decodeURIComponent(req.params.title);
    const post = await db.get("SELECT * FROM posts WHERE title = ?", [postTitle]);

    if(post) {
        res.render("edit.ejs", { post });
    } else {
        res.status(404).send("Post not found 😵");
    };
});

app.post("/update/:title", async (req, res) =>{
    const oldTitle = decodeURIComponent(req.params.title);
    const { title, content } = req.body;

    const post = await db.get("SELECT * FROM posts WHERE title = ?", [oldTitle]);

    if(post) {
        await db.run("UPDATE posts SET title = ?, content = ? WHERE title = ?", [title, content, oldTitle]);
        res.redirect("/");
    } else {
        res.status(404).send("Post not found 😵");
    }
});

app.get("/delete/:title", async (req, res) =>{
    const postTitle = decodeURIComponent(req.params.title);
    await db.run("DELETE FROM posts WHERE title = ?", [postTitle]);
    res.redirect("/");
});

app.listen(port, () =>{
    console.log(`Listen on port ${port}`);
});