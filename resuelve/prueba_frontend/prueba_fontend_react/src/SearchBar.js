import ReactDOM from 'react-dom';
import React, {Component} from 'react';
import $ from 'jquery'
import autocomplete from 'jquery';
//'use strict';

const e = React.createElement;
class SearchResults extends React.Component{
 constructor (props){
	 super(props);
 }
 render(){
	return(
		<div id="search-results">{this.props.requestedText}</div>
	)
 }
}
/* BARRA DE B[USQUEDA DE FILMES */
class SearchBar extends React.Component {
  constructor(props) {
    super(props);
    this.availableTags=[];
  }
  insertTag(tag){
	for(var i in this.availableTags){
		if (this.availableTags[i]==tag){
			return;
		}
	}
  	this.availableTags.push(tag);
  }
  submitRequest(e){
	console.log("submitRequest");
	e.preventDefault();
	ReactDOM.render(<SearchResults requestedText={document.getElementById("searchTextInput").value}/>,document.getElementById("search-results-wrapper"));
}
  cargarFuente(){
	  console.log("cargar fuente");
  	}
  componentDidMount(){
	  this.cargarFuente();
  	}
  render() {
	return (
	 <div className='ui-widget'>
		<form onSubmit={this.submitRequest}>
		<label htmlFor='search'>Buscar:</label>
		<input id='searchTextInput'/>
		<input type="submit"  />
		</form>
		<SearchResults/>
	 </div>
	);
 	}
}



/* Estoy probando extender clases, pero me parece que ReactJS puede 
 * implementar mucho mejor el despliegue de elementos sin hacer esta 
 * separacion
 * */
class SearchBarFilm extends SearchBar{
  constructor(props) {
    super(props);
    this.availableTags=[];
  }
  indexarFilm(film){
	this.insertTag(film.director);
	this.insertTag(film.producer);
	this.insertTag(film.title);
  }
  cargarFuente(){
	  console.log("cargar fuente de filmes");
	  const requestURL = 'https://ghibliapi.herokuapp.com/films';
	  const request = new XMLHttpRequest();
	  request.open('GET', requestURL);
	  request.responseType = 'json';
	  request.send();
	  console.log("componentDidmount")
	  var ref=this;
	  request.onload = function() {
		const films= request.response;
		console.log("films loaded");
		var availableTags=[];
		for (var i in films){
			var film=films[i];
			ref.indexarFilm(film);
			//availableTags.push(film.title);
		}
		$( function() {
			window.$( "#searchTextInput" ).autocomplete({
				      source: ref.availableTags
				    });
		console.log('wooha!');	      
		    } );
		  }
  	}
  render() {
	return (
	 <div className='ui-widget'>
		<form onSubmit={this.submitRequest}>
		<label htmlFor='searchBarFilm'>Film:</label>
		<input id='searchTextInput'/>
		<input type="submit"  />
		</form>
		<div id="search-results-wrapper"></div>
	<SearchResults/>
	 </div>
	);
 	}
}

export default SearchBarFilm;
