'use client'

import { useEffect, useMemo, useState } from 'react'
import { CATEGORIES, type Platform } from '../lib/tools-data'

function matchesPlatform(toolPlatforms: Platform[], tab: Platform | 'all') {
  if (tab === 'all') return true
  return toolPlatforms.includes(tab)
}

function platformIcon(p: Platform) {
  return p === 'win' ? '🪟' : '🐧'
}

function platformName(p: Platform) {
  return p === 'win' ? 'Windows' : 'Linux'
}

export default function ToolsCatalog() {
  const [q, setQ] = useState('')
  const [tab, setTab] = useState<Platform | 'all'>('all')
  const [copied, setCopied] = useState<string | null>(null)

  useEffect(() => {
    if (!copied) return
    const t = window.setTimeout(() => setCopied(null), 1200)
    return () => window.clearTimeout(t)
  }, [copied])

  const filtered = useMemo(() => {
    const query = q.trim().toLowerCase()

    const byPlatform = CATEGORIES.map((c) => {
      const tools = c.tools.filter((t) => matchesPlatform(t.platforms, tab))
      return { ...c, tools }
    })

    const bySearch = query
      ? byPlatform.map((c) => {
          const tools = c.tools.filter((t) => {
            const hay = [t.name, t.desc, c.title, t.stable, t.latest].join(' ').toLowerCase()
            return hay.includes(query)
          })
          return { ...c, tools }
        })
      : byPlatform

    return bySearch.filter((c) => c.tools.length > 0)
  }, [q, tab])

  function copyCmd(toolId: string, cmd: string) {
    navigator.clipboard
      .writeText(cmd)
      .then(() => setCopied(toolId))
      .catch(() => setCopied(null))
  }

  function CmdBox({ platform, cmd, toolId }: { platform: Platform; cmd: string; toolId: string }) {
    const prompt = platform === 'win' ? 'PS>' : '$'
    return (
      <div className="cmd-box">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <div className="text-xs text-m opacity-70 mb-2">{platformName(platform)} command</div>
            <code className="block break-all">{prompt} {cmd}</code>
          </div>
          <div className="shrink-0">
            <button
              className="copy-btn"
              onClick={() => copyCmd(toolId, cmd)}
              aria-label={`Copy ${platformName(platform)} command`}
            >
              {copied === toolId ? '✓ Copied' : 'Copy'}
            </button>
          </div>
        </div>
      </div>
    )
  }

  function StablePill({ stable }: { stable: string }) {
    return (
      <span className="pill pill-stable">
        <span className="pill-dot" style={{ background: 'var(--green)' }} /> stable {stable}
      </span>
    )
  }

  function LatestPill({ latest }: { latest: string }) {
    return (
      <span className="pill pill-latest">
        <span className="pill-dot" style={{ background: 'var(--cyan)' }} /> latest {latest}
      </span>
    )
  }

  return (
    <section className="px-6 py-16">
      <div className="container mx-auto px-0 max-w-6xl">
        <div className="flex items-end justify-between gap-6 mb-8 reveal">
          <div>
            <h2 className="text-2xl md:text-3xl font-bold text-center md:text-left">Tool Catalog</h2>
            <p className="text-m mt-2 text-center md:text-left opacity-90">
              Search tools by name, category, or version — stable + latest included.
            </p>
          </div>

          <div className="w-full md:w-[420px]">
            <div className="relative">
              <span className="absolute left-3 top-1/2 -translate-y-1/2 text-m opacity-70">&gt;</span>
              <input
                className="w-full pl-7 pr-16 py-3 rounded-lg bg-card border border-c text-sm outline-none focus:ring-2 focus:ring-cyan/30"
                placeholder="Search tools (e.g. dns, node, vlc)"
                value={q}
                onChange={(e) => setQ(e.target.value)}
              />
              {q.trim() ? (
                <button
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-xs opacity-70 hover:opacity-100 transition"
                  onClick={() => setQ('')}
                  aria-label="Clear search"
                >
                  ✕
                </button>
              ) : null}
            </div>
          </div>
        </div>

        <div className="flex flex-wrap gap-3 mb-10 justify-center md:justify-start reveal" role="tablist" aria-label="Platform filter">
          <button
            className={`px-4 py-2 rounded-lg border transition ${tab === 'all' ? 'bg-card border-c' : 'bg-transparent border-c/60 hover:bg-card/60'}`}
            onClick={() => setTab('all')}
          >
            All
          </button>
          <button
            className={`px-4 py-2 rounded-lg border transition ${tab === 'win' ? 'bg-card border-c' : 'bg-transparent border-c/60 hover:bg-card/60'}`}
            onClick={() => setTab('win')}
          >
            {platformName('win')}
          </button>
          <button
            className={`px-4 py-2 rounded-lg border transition ${tab === 'linux' ? 'bg-card border-c' : 'bg-transparent border-c/60 hover:bg-card/60'}`}
            onClick={() => setTab('linux')}
          >
            Linux &amp; Ubuntu
          </button>
        </div>

        <div className="grid md:grid-cols-2 gap-6">
          {filtered.map((cat, idx) => (
            <div key={cat.id} className={`bg-card border border-c rounded-xl p-6 reveal ${idx % 2 === 0 ? 'reveal-left' : 'reveal-right'}`}>
              <div className="flex items-start justify-between gap-4 mb-2">
                <div>
                  <h3 className="text-lg font-semibold">{cat.title}</h3>
                  <p className="text-m opacity-90 text-sm mt-1">{cat.desc}</p>
                </div>
                <div className="text-xs opacity-70">{cat.tools.length} tools</div>
              </div>

              <div className="space-y-4 mt-6">
                {cat.tools.map((t) => {
                  const hasWin = t.platforms.includes('win') && !!t.cmdWin
                  const hasLinux = t.platforms.includes('linux') && !!t.cmdLinux

                  const showWin = tab === 'all' ? hasWin : tab === 'win'
                  const showLinux = tab === 'all' ? hasLinux : tab === 'linux'

                  return (
                    <div key={t.id} className="tool-card">
                      <div className="mini-term-head">
                        <div className="mini-term-dots" aria-hidden="true">
                          <span className="mini-dot" style={{ background: '#ff5f57' }} />
                          <span className="mini-dot" style={{ background: '#febc2e' }} />
                          <span className="mini-dot" style={{ background: '#28c840' }} />
                        </div>

                        <div className="mini-term-title">{t.name}</div>

                        <div className="ml-auto flex flex-wrap justify-end gap-2">
                          {t.platforms.map((p) => (
                            <span key={p} className="platform-pill">
                              {platformIcon(p)} {platformName(p)}
                            </span>
                          ))}
                          {t.note ? <span className="platform-pill">{t.note}</span> : null}
                        </div>
                      </div>

                      <div className="mini-term-body">
                        <div className="flex flex-wrap gap-2 mb-3">
                          <StablePill stable={t.stable} />
                          <LatestPill latest={t.latest} />
                        </div>

                        <div className="text-m text-sm opacity-90">{t.desc}</div>

                        <div className="mt-4 space-y-3">
                          {showWin && t.cmdWin ? <CmdBox platform="win" cmd={t.cmdWin} toolId={t.id} /> : null}
                          {showLinux && t.cmdLinux ? <CmdBox platform="linux" cmd={t.cmdLinux} toolId={t.id} /> : null}

                          {(!showWin && !showLinux) || (!t.cmdWin && !t.cmdLinux) ? (
                            <div className="text-xs opacity-70">No command available for this filter.</div>
                          ) : null}
                        </div>
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>
          ))}
        </div>

        {filtered.length === 0 ? (
          <div className="mt-12 text-center text-m opacity-80 reveal">No tools match your search.</div>
        ) : null}
      </div>
    </section>
  )
}

