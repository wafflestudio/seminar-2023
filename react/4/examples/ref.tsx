import { useRef, useState } from 'react'

function App() {
  const [first, setFirst] = useState("");
  const [second, setSecond] = useState("");
  const [third, setThird] = useState("");
  return <div>
    <label>전화번호:
    <input type="number" value={first} onChange={(e) => {
      const newFirst = e.target.value;
      setFirst(newFirst);
      if (first.length < newFirst.length && newFirst.length === 3) {
        // 새로 입력된 길이가 3이면 다음 input으로 넘어간다
        // TODO
      }
    }} />
    -
    <input type="number" value={second} ref={secondInputRef} onChange={(e) => {
      const newSecond = e.target.value;
      setSecond(newSecond);
      if (second.length < newSecond.length && newSecond.length === 4) {
        // 새로 입력된 길이가 4면 다음 input으로 넘어간다
        // TODO
      }
    }} />
    -
    <input type="number" value={third} ref={thirdInputRef} onChange={(e) => {
      const newThird = e.target.value;
      setThird(newThird);
    }} />
    </label>
  </div>;
}

export default App
