import { EthProvider } from "./contexts/EthContext";
import Navigation from "./components/Navbar/";
import Home from "./components/Home/";
import Demo from "./components/Demo";
import Footer from "./components/Footer";

function App() {
  return (
    <EthProvider>
      <div id="App">
        <div className="container">
          <Intro />
          <hr />
          <Setup />
          <hr />
          <Demo />
          <hr />
          <Footer />
        </div>
      </div>
    </EthProvider>
  );
}

export default App;
