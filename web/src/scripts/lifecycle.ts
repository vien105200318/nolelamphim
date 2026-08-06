export type PageInit = () => (() => void) | void

const setups: PageInit[] = []
let disposes: Array<() => void> = []

export function registerPageInit(setup: PageInit): void {
  setups.push(setup)
}

function runAll(): void {
  for (const d of disposes) {
    try {
      d()
    } catch {
      /* ignore */
    }
  }
  disposes = []
  for (const s of setups) {
    try {
      const d = s()
      if (d) disposes.push(d)
    } catch (e) {
      console.error('[page-init]', e)
    }
  }
}

function disposeAll(): void {
  for (const d of disposes) {
    try {
      d()
    } catch {
      /* ignore */
    }
  }
  disposes = []
}

declare global {
  interface Window {
    __nllpPageInit?: { run: () => void; dispose: () => void }
  }
}

if (typeof window !== 'undefined') {
  window.__nllpPageInit = { run: runAll, dispose: disposeAll }
}
