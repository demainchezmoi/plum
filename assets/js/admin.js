import Elm from '../elm/Main.elm';

const elmDiv = document.querySelector('#elm_target');

if (elmDiv) { Elm.Main.embed(elmDiv, { apiToken: getToken() }); }

function getToken() {
  const token_meta = $('meta[name=token]');
  return token_meta.attr('content');
}
