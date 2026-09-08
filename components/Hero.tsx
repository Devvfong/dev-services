'use client'

import { useEffect } from 'react'

export default function Hero() {
  useEffect(() => {
    const bg = document.getElementById('dotBg')
    if (!bg) return
    for (let i = 0; i < 30; i++) {
      const d = document.createElement('div')
      d.className = 'dot'
      const size = Math.random() * 4 + 2
      d.style.cssText = `width:${size}px;height:${size}px;left:${Math.random() * 100}%;top:${Math.random() * 100}%;animation:float ${3 + Math.random() * 4}s ease-in-out ${Math.random() * 3}s infinite`
      bg.appendChild(d)
    }
  }, [])

  return (
    <section className="py-24 relative overflow-hidden">
      <div className="dot-bg" id="dotBg" />
      <div className="container mx-auto px-6 max-w-4xl relative z-10">
        <div className="text-center">
          <h1 className="text-4xl md:text-5xl font-bold mb-6 leading-tight hero-anim">
            Ultimate Windows
            <br />
            Developer &amp; System Suite
          </h1>
          <p className="text-lg text-m mb-12 max-w-2xl mx-auto hero-anim hero-anim-d1">
            Modern, modular PowerShell utility suite with interactive TUI for activation tools, dev environment setup,
            system maintenance, and network utilities.
          </p>

          <div className="flex flex-col md:flex-row gap-4 justify-center items-center hero-anim hero-anim-d2">
            <a
              href="https://github.com/Devvfong/dev-services/raw/master/dist/DevServices.exe"
              className="btn-p px-8 py-3 rounded inline-flex items-center gap-2 text-sm font-medium"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
              </svg>
              Download .exe
              <span className="text-xs opacity-70">(119 KB)</span>
            </a>
            <a
              href="https://github.com/Devvfong/dev-services"
              target="_blank"
              className="btn-s px-8 py-3 rounded inline-flex items-center gap-2 text-sm font-medium"
            >
              View Source
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
              </svg>
            </a>
          </div>
        </div>
      </div>
    </section>
  )
}
