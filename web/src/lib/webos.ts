export function isWebOS(): boolean {
  if (typeof window === 'undefined') return false;
  return !!(window as { webOS?: unknown }).webOS || navigator.userAgent.includes('WebOS');
}

export function initWebOSRemote() {
  if (typeof window === 'undefined') return;

  const KEY_MAP: Record<number, string> = {
    37: 'ArrowLeft',
    38: 'ArrowUp',
    39: 'ArrowRight',
    40: 'ArrowDown',
    13: 'Enter',
    8: 'Backspace',
    27: 'Escape',
    461: 'Backspace',
    48: '0', 49: '1', 50: '2', 51: '3', 52: '4',
    53: '5', 54: '6', 55: '7', 56: '8', 57: '9',
    415: 'MediaPlayPause',
    413: 'MediaStop',
    19: 'MediaPause',
  };

  window.addEventListener('message', (event) => {
    if (event.data?.type !== 'webos-keydown') return;

    const { keyCode } = event.data;
    const key = KEY_MAP[keyCode] || event.data.key;

    if (key === 'Backspace') {
      window.history.back();
      return;
    }

    window.dispatchEvent(new KeyboardEvent('keydown', {
      key,
      keyCode,
      bubbles: true,
      cancelable: true,
    }));
  });
}
