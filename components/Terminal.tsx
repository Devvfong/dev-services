'use client'

import { useEffect } from 'react'

export default function Terminal() {
  useEffect(() => {
    const el = document.getElementById('terminal')
    if (!el) return
    const term: HTMLElement = el

    const green = '#4ade80', cyan = '#22d3ee', gray = '#71717a', white = '#d4d4d8', yellow = '#facc15'

    const scenes = [
      {
        lines: [
          { text: 'PS C:\\Users\\Dev> ', color: gray, speed: 0, pause: 200 },
          { text: '.\\DevServices.exe', color: cyan, speed: 40, pause: 600 },
          { text: '\n', color: gray, speed: 0, pause: 300 },
          {
            text: '  _____                ____  _ _\n |  __ \\              / __ \\(_|_)\n | |  | | _____   __ | |  | |_ _\n | |  | |/ _ \\ \\ / / | |  | | | |\n | |__| |  __/\\ V /  | |__| | | |\n |_____/ \\___| \\_/    \\___\\_\\_|_|\n',
            color: green,
            speed: 0,
            block: true,
            pause: 500,
          },
          { text: '\n Ultimate Windows Developer & System Suite v2.0.0\n', color: white, speed: 10, pause: 200 },
          { text: ' [ Home ] | ADMINISTRATOR | JetBrains Mono\n\n', color: gray, speed: 10, pause: 400 },
          { text: ' > [1] Legacy & Activation Utilities\n', color: white, speed: 15, pause: 100 },
          { text: '   [2] Developer Environment Suite\n', color: gray, speed: 15, pause: 100 },
          { text: '   [3] System Maintenance & Tweaks\n', color: gray, speed: 15, pause: 100 },
          { text: '   [4] Network Utilities & DNS Switcher\n', color: gray, speed: 15, pause: 100 },
          { text: '   [5] Settings & Personalization\n', color: gray, speed: 15, pause: 2000 },
        ],
      },
      {
        lines: [
          { text: 'PS C:\\Users\\Dev> ', color: gray, speed: 0, pause: 200 },
          { text: 'DevServices -Module SystemTweaks', color: cyan, speed: 35, pause: 600 },
          { text: '\n\n', color: gray, speed: 0, pause: 200 },
          { text: ' [*] Deep Temporary Files & Junk Cleaner\n', color: white, speed: 12, pause: 300 },
          { text: ' [~] Scanning junk folders...\n', color: yellow, speed: 12, pause: 800 },
          { text: ' [+] Cleaning User\\Temp      ', color: gray, speed: 10, pause: 200 },
          { text: '✓\n', color: green, speed: 0, pause: 150 },
          { text: ' [+] Cleaning Windows\\Temp   ', color: gray, speed: 10, pause: 200 },
          { text: '✓\n', color: green, speed: 0, pause: 150 },
          { text: ' [+] Cleaning Prefetch       ', color: gray, speed: 10, pause: 200 },
          { text: '✓\n', color: green, speed: 0, pause: 150 },
          { text: ' [+] Clearing CrashDumps     ', color: gray, speed: 10, pause: 200 },
          { text: '✓\n', color: green, speed: 0, pause: 150 },
          { text: ' [+] Emptying Recycle Bin     ', color: gray, speed: 10, pause: 200 },
          { text: '✓\n', color: green, speed: 0, pause: 400 },
          { text: '\n [✓] Purged 1,247 cached items. Freed 2.3 GB.\n', color: green, speed: 12, pause: 2500 },
        ],
      },
      {
        lines: [
          { text: 'PS C:\\Users\\Dev> ', color: gray, speed: 0, pause: 200 },
          { text: 'DevServices -Module DevTools', color: cyan, speed: 35, pause: 600 },
          { text: '\n\n', color: gray, speed: 0, pause: 200 },
          { text: ' [*] Runtime Environment Scanner\n\n', color: white, speed: 12, pause: 400 },
          { text: '   Node.js     v22.5.0     ', color: gray, speed: 8, pause: 100 },
          { text: '✓\n', color: green, speed: 0, pause: 100 },
          { text: '   Python      v3.12.4     ', color: gray, speed: 8, pause: 100 },
          { text: '✓\n', color: green, speed: 0, pause: 100 },
          { text: '   Git         v2.46.0     ', color: gray, speed: 8, pause: 100 },
          { text: '✓\n', color: green, speed: 0, pause: 100 },
          { text: '   Docker      v27.1.1     ', color: gray, speed: 8, pause: 100 },
          { text: '✓\n', color: green, speed: 0, pause: 100 },
          { text: '   Rust        v1.80.0     ', color: gray, speed: 8, pause: 100 },
          { text: '✓\n', color: green, speed: 0, pause: 100 },
          { text: '   Go          -----       ', color: gray, speed: 8, pause: 100 },
          { text: '✗ not found\n', color: '#f87171', speed: 0, pause: 400 },
          { text: '\n [i] 5/6 tools detected. Install missing? (Y/N)\n', color: cyan, speed: 12, pause: 2500 },
        ],
      },
      {
        lines: [
          { text: 'PS C:\\Users\\Dev> ', color: gray, speed: 0, pause: 200 },
          { text: 'DevServices -Module Network', color: cyan, speed: 35, pause: 600 },
          { text: '\n\n', color: gray, speed: 0, pause: 200 },
          { text: ' [*] Quick DNS Switcher\n\n', color: white, speed: 12, pause: 300 },
          { text: '   [1] Cloudflare    1.1.1.1\n', color: gray, speed: 12, pause: 100 },
          { text: '   [2] Google        8.8.8.8\n', color: gray, speed: 12, pause: 100 },
          { text: '   [3] Quad9         9.9.9.9\n', color: gray, speed: 12, pause: 100 },
          { text: '   [4] AdGuard       94.140.14.14\n', color: gray, speed: 12, pause: 300 },
          { text: '\n > Selecting Cloudflare DNS...\n', color: white, speed: 15, pause: 500 },
          { text: ' [~] Flushing DNS cache...       ', color: yellow, speed: 10, pause: 400 },
          { text: '✓\n', color: green, speed: 0, pause: 200 },
          { text: ' [~] Applying DNS 1.1.1.1...     ', color: yellow, speed: 10, pause: 400 },
          { text: '✓\n', color: green, speed: 0, pause: 200 },
          { text: ' [~] Verifying connectivity...    ', color: yellow, speed: 10, pause: 400 },
          { text: '✓\n', color: green, speed: 0, pause: 300 },
          { text: '\n [✓] DNS switched to Cloudflare successfully!\n', color: green, speed: 12, pause: 2500 },
        ],
      },
      // Scene 5: Full Tool Catalog Overview
      {
        lines: [
          { text: 'PS C:\\Users\\Dev> ', color: gray, speed: 0, pause: 200 },
          { text: 'DevServices -Catalog --list-all', color: cyan, speed: 35, pause: 600 },
          { text: '\n\n', color: gray, speed: 0, pause: 200 },
          { text: ' [*] Full DevServices Tool Catalog\n', color: white, speed: 12, pause: 300 },
          { text: '   [1] Legacy & Activation Utilities     🪟\n', color: gray, speed: 10, pause: 50 },
          { text: '   [2] Developer Environment Suite        🪟🐧\n', color: gray, speed: 10, pause: 50 },
          { text: '   [3] System Maintenance & Tweaks        🪟🐧\n', color: gray, speed: 10, pause: 50 },
          { text: '   [4] Network Utilities & DNS Switcher   🪟🐧\n', color: gray, speed: 10, pause: 60 },
          { text: '   [5] Settings & Personalization          🪟🐧\n', color: gray, speed: 10, pause: 60 },
          { text: '   [6] Linux Package Management            🐧\n', color: gray, speed: 10, pause: 60 },
          { text: '   [7] Linux CLI & Terminal Utilities      🐧\n', color: gray, speed: 10, pause: 60 },
          { text: '   [8] Media & Content Creation            🪟🐧\n', color: gray, speed: 10, pause: 60 },
          { text: '   [9] Linux Backup, Security & Firewall   🐧\n', color: gray, speed: 10, pause: 60 },
          { text: '\n [i] Showing stable + latest versions for all tools.\n', color: cyan, speed: 12, pause: 2500 },
        ],
      },
    ]

    let sceneIdx = 0
    let running = false

    function sleep(ms: number) {
      return new Promise((r) => setTimeout(r, ms))
    }

    function span(text: string, color: string) {
      const s = document.createElement('span')
      s.style.color = color
      s.textContent = text
      return s
    }

    async function typeScene(scene: any) {
      term.innerHTML = ''
      const cursor = document.createElement('span')
      cursor.className = 'cursor'
      term.appendChild(cursor)

      for (const seg of scene.lines) {
        if (seg.block) {
          const pre = document.createElement('pre')
          pre.style.cssText = 'margin:0;padding:0;font:inherit;color:' + seg.color + ';white-space:pre;display:inline;background:none;border:none;'
          pre.textContent = seg.text
          term.insertBefore(pre, cursor)
          term.scrollTop = term.scrollHeight
          await sleep(seg.pause || 0)
        } else if (seg.speed > 0) {
          for (const ch of seg.text) {
            const s = span(ch, seg.color)
            term.insertBefore(s, cursor)
            term.scrollTop = term.scrollHeight
            await sleep(seg.speed)
          }
        } else {
          const s = span(seg.text, seg.color)
          term.insertBefore(s, cursor)
        }
        await sleep(seg.pause || 0)
      }

      await sleep(1500)
    }

    async function loop() {
      running = true
      while (running) {
        await typeScene(scenes[sceneIdx])
        sceneIdx = (sceneIdx + 1) % scenes.length
        await sleep(500)
      }
    }

    const termObs = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting && !running) loop()
        })
      },
      { threshold: 0.3 }
    )

    // start when parent is visible
    const parent = term.parentElement?.parentElement
    if (parent) termObs.observe(parent)

    return () => {
      running = false
      termObs.disconnect()
    }
  }, [])

  return (
    <div className="term" id="terminalWrap">
      <div className="term-head">
        <div className="term-dot" style={{ background: '#ff5f57' }} />
        <div className="term-dot" style={{ background: '#febc2e' }} />
        <div className="term-dot" style={{ background: '#28c840' }} />
        <span className="text-sm text-gray-500 ml-2">Windows PowerShell</span>
      </div>
      <div className="term-body" id="terminal" />
    </div>
  )
}
