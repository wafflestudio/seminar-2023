import {useState} from "react";

function App() {
  const [display, setDisplay] = useState([]);
  const [coin, setCoin] = useState("H");

  function longTask() {
    const req = new XMLHttpRequest();
    req.open("GET", "http://localhost:8000", false);
    req.send(null);
    if (req.status === 200) {
      const json = JSON.parse(req.responseText);
      setDisplay([...display, json]);
    } else {
      console.log(req.status, req.responseText);
    }
  }

  function asyncTask() {
    fetch("http://localhost:8000")
      .then(res => {
        if (res.status === 200)
          return res.json().then(json => setDisplay([...display, json]));
        else
          return res.text().then(text => console.error(res.status, text));
      });
  }

  function flip() {
    setCoin((coin) => coin + (Math.random() < 0.5 ? "H" : "T"));
  }

  return (
    <div style={{ display: "flex" }}>
      <p style={{border: "1px solid", background: "#eee", margin: "5px", flex: "1"}}>
        <button onClick={() => longTask()}>sync request</button><br/>
        <button onClick={() => asyncTask()}>async request</button><br/>
      </p>
      <ul style={{border: "1px solid", background: "#eee", margin: "5px", flex: "1"}}>
        {display.map((x,i) => <li key={i}>{JSON.stringify(x)}</li>)}
      </ul>
      <p style={{border: "1px solid", background: "#eee", margin: "5px", flex: "1", lineBreak: "anywhere"}}>
        <button onClick={() => flip()}>flip</button><br/>
        coin: {coin}
      </p>
    </div>
  );
}

export default App;
