const express = require("express");
const app = express();

app.get("/health", (req, res) => {
  res.json({
    status: "UP",
    message: "Node.js DevOps App is running 🚀"
  });
});

app.listen(3000, () => {
  console.log("App running on port 3000");
});

