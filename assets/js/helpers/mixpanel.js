export function identify(user) {
  if (typeof mixpanel !== 'undefined') {

    if (typeof just_inserted !== 'undefined' && just_inserted === true) {
      console.log('alias');
      mixpanel.alias(user.id)
    } else {
      console.log('identify');
      mixpanel.identify(user.id);
    }

    mixpanel.people.set({
      $email: user.email,
      $first_name: user.first_name,
      $last_name: user.last_name
    });
  }
}

export function track(event, payload) {
  typeof mixpanel !== 'undefined' && mixpanel.track(event, payload);
}
