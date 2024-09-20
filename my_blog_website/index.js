import express from "express";

const app = express();
const port = 3000;
const posts = [];
app.use(express.static("public"));
app.use(express.urlencoded({extended: true }));

app.get("/", (req, res) => {
    res.render("index.ejs", { posts: posts });
});

app.post("/create-post", (req, res) =>{
    const { title, content } = req.body;
    posts.push({ title, content });
    res.redirect("/");
});


app.listen(port, () =>{
    console.log(`Listen on port ${port}`);
});