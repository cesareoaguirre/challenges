import React, {Component} from 'react';
import $ from 'jquery'
import autocomplete from 'jquery';
//'use strict';

const e = React.createElement;
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
		<input id='search'/>
		<input type="submit"  />
		</form>
	 </div>
	);
 	}
}




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
			window.$( "#searchBarFilm" ).autocomplete({
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
		<input id='searchBarFilm'/>
		<input type="submit"  />
		</form>
	 </div>
	);
 	}
}
export default SearchBarFilm;
