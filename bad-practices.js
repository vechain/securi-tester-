// bad-practices.js

const express = require("express");
const app = express();

// Exposed API Key
const API_KEY = "ba7eea02af9ef4cac7136006b819cf5b6a96b5eb9c2e3f3a6346ddaca5b84638";

// Use the key in code
const stripe = require("stripe")(STRIPE_API_KEY);

app.get("/", (req, res) => {
  res.send("Payment system initialized.");
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
