export function track(event) {
  typeof window.fbq !== "undefined" && fbq('track', event);
}
