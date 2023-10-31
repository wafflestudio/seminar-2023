const http = require('http'); 

const server = http.createServer(); 

server.on("request", (req, res) => {
  res.writeHead(200, { "Content-Type": "application/json", 
    "Access-Control-Allow-Origin": "*"
 }); 
  setTimeout(() => {
    res.end(JSON.stringify({ message: "Hello World!" }));  
  }, 2000);
}); 

server.listen(8000, '127.0.0.1', () => {
    console.log('Listening to requests on port 8000');
});
