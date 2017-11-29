import url from 'urljs';

export function parseLocation() {
  const location = url.getLocation();

  if (location.indexOf("?") > -1) {
    return decodeURI(location)
      .split('?')
      .slice(-1)[0]
      .split('&')
      .map((e) => e.split('='))
      .reduce((acc, keyVal) => {
        const key = keyVal[0];
        const val = keyVal[1];
        if (key.slice(-2) === '[]') {
          acc[key.slice(0, -2)] = (acc[key.slice(0, -2)] || []).concat([val])
        } else {
          acc[key] = val
        }
        return acc;
      }, {})
  }
  else {
    return {};
  }
};
