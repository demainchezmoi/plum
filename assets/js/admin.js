import Elm from '../elm/Main.elm';

const elmDiv = document.querySelector('#elm_target');

if (elmDiv) { Elm.Main.embed(elmDiv); }
