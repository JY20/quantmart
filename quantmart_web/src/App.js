import logo from './logo.svg';
import './App.css';
import StrategyPage from "./pages/StrategyPage";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import { AppProvider } from './components/AppProvider';

function App() {
  return (
    <AppProvider>
      <Navbar />
      <StrategyPage />
      <Footer />
    </AppProvider>
  );
}

export default App;
