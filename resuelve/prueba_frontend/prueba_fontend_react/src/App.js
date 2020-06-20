import React from 'react';
import logo from './logo.svg';
import './App.css';
import SearchBarFilm from "./SearchBarFilm.js"
function App() {
  return (
    <div className="App">
      <header className="App-header">
         <p>Filmes de Studio Ghibli</p>
	 <SearchBarFilm/>
      </header>
    </div>
  );
}

export default App;
