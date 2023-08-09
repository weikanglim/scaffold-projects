import catpaw from './catpaw.png'
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Button />
      </header>
    </div>
  );
}

function Button() {
  var pawToggled = false;
  var myTimeout;

  function callbackToggle() {
    return function () {
        if (pawToggled) {
            document.getElementById("main-button").click();
        } else {
        }
    }
  }
  function togglePaw() {
    if (!pawToggled) {
      // Runs when we toggle the button
      document.getElementsByClassName("catpaw-container")[0].classList.add("catpaw-extended");
      document.getElementById("main-button").classList.add("active");
      myTimeout = setTimeout(callbackToggle(), 600);
    } else {
      document.getElementsByClassName("catpaw-container")[0].classList.remove("catpaw-extended");
      document.getElementById("main-button").classList.remove("active");
      clearTimeout(myTimeout);
    }

    pawToggled = !pawToggled;
  }

  return (
    <div className="centered">
    <button type="button" className="btn btn-lg btn-toggle" data-toggle="button" aria-pressed="false"
            onClick={togglePaw} id="main-button" title="A button for cats">
            <span className="handle"></span>
        </button>
        <div className="catpaw-container">
            <img className="catpaw-image" alt="The paw of a cat" src={catpaw} />
        </div>
        <div>
            <h1>Press the Button</h1>
        </div>
    </div>
  );
}

export default App;
