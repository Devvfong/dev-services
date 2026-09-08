'use client'

import { useEffect } from 'react'

export default function Features() {
  useEffect(() => {
    const obs = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting) e.target.classList.add('visible')
        })
      },
      { threshold: 0.15, rootMargin: '0px 0px -40px 0px' }
    )

    document.querySelectorAll('.reveal, .reveal-left, .reveal-right').forEach((el) => obs.observe(el))
    return () => obs.disconnect()
  }, [])

  return (
    <section className="py-16">
      <div className="container mx-auto px-6 max-w-5xl">
        <h2 className="text-2xl md:text-3xl font-bold text-center mb-10 reveal">Why DevServices</h2>

        <div className="grid md:grid-cols-2 gap-6">
          {[
            {
              title: 'Activation Tools TUI',
              desc: 'A guided interface to manage Windows activation scenarios safely and clearly.',
            },
            {
              title: 'System Maintenance',
              desc: 'Cleanup, optimization, and routine tweaks with transparent progress output.',
            },
            {
              title: 'Developer Environment',
              desc: 'One-click setup paths for common tools and runtimes.',
            },
            {
              title: 'Network Utilities',
              desc: 'DNS switcher, quick checks, and connectivity helpers.',
            },
          ].map((c, idx) => (
            <div
              key={c.title}
              className="bg-card border border-c rounded-xl p-6 reveal"
              style={{ transitionDelay: `${idx * 0.08}s` }}
            >
              <div className="text-green text-lg font-semibold mb-2">{c.title}</div>
              <div className="text-m leading-relaxed">{c.desc}</div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
