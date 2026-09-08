'use client'

import { useMemo, useState } from 'react'
import { CATEGORIES, type Platform } from '../lib/tools-data'

function platformLabel(p: Platform) {
  return p === 'win' ? 'Windows' : 'Linux'
}

function matchesPlatform(toolPlatforms: Platform[], tab: Platform | 'all') {
  if (tab === 'all') return true
  return toolPlatforms.includes(tab)
}

export default function ToolsCatalog() {
  const [q, setQ] = useState('')
  const [tab, setTab] = useState<Platform | 'all'>('all')

  const filtered = useMemo(() => {
    const query = q.trim().toLowerCase()
    const byPlatform = CATEGORIES.map((c) => {
      const tools = c.tools.filter((t) => matchesPlatform(t.platforms, tab))
      return { ...c, tools }
    })

    const bySearch = query
      ? byPlatform.map((c) => {
          const tools = c.tools.filter((t) => {
            const hay = [t.name, t.desc, c.title, c.desc, t.stable, t.latest].join(' ').toLowerCase()
            return hay.includes(query)
          })
          return { ...c, tools }
        })
      : byPlatform

    return bySearch.filter((c) => c.tools.length > 0)
  }, [q, tab])

  function renderCopy(cmd: string) {
    return (
      <div className="bg-alt border border-c rounded-lg p-4 text-sm">
        <code className="break-all">{cmd}</code>
        <button
          className="ml-3 inline-flex items-center gap-2 text-xs opacity-70 hover:opacity-100 transition"
          onClick={async () => {
            try {
              await navigator.clipboard.writeText(cmd)
            } catch {
              // no-op
            }
          }}
          aria-label="Copy command"
        >
          Copy
        </button>
      </div>
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
                className="w-full pl-7 pr-3 py-3 rounded-lg bg-card border border-c text-sm outline-none focus:ring-2 focus:ring-cyan/30"
                placeholder="Search tools (e.g. dns, node, vlc)"
                value={q}
                onChange={(e) => setQ(e.target.value)}
              />
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
            Windows
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
                  const isWin = t.platforms.includes('win')
                  const isLinux = t.platforms.includes('linux')

                  const activePlatform = tab === 'all' ? null : tab
                  const cmd =
                    activePlatform === 'win' ? t.cmdWin :
                    activePlatform === 'linux' ? t.cmdLinux :
                    // all: prefer showing whichever platform we have for the active tab; if both, show both in two blocks
                    null

                  return (
                    <div key={t.id} className="border border-c/60 rounded-lg p-4">
                      <div className="flex items-start justify-between gap-4">
                        <div>
                          <div className="font-medium">{t.name}</div>
                          <div className="text-m text-sm opacity-90 mt-1">{t.desc}</div>
                        </div>
                        <div className="text-xs text-m whitespace-nowrap">
                          <div>● stable {t.stable}</div>
                          <div>● latest {t.latest}</div>
                        </div>
                      </div>

                      <div className="flex flex-wrap gap-2 mt-3">
                        {t.platforms.map((p) => (
                          <span key={p} className="text-xs border border-c/60 rounded-full px-2 py-1 opacity-90">
                            {p === 'win' ? '🪟 Windows' : '🐧 Linux'}
                          </span>
                        ))}
                        {t.note ? <span className="text-xs border border-c/60 rounded-full px-2 py-1">{t.note}</span> : null}
                      </div>

                      <div className="mt-4 space-y-3">
                        {tab === 'all' ? (
                          <>
                            {isWin && t.cmdWin ? (
                              <div>
                                <div className="text-xs opacity-70 mb-2">Windows command</div>
                                {renderCopy(t.cmdWin)}
                              </div>
                            ) : null}
                            {isLinux && t.cmdLinux ? (
                              <div>
                                <div className="text-xs opacity-70 mb-2">Linux command</div>
                                {renderCopy(t.cmdLinux)}
                              </div>
                            ) : null}
                          </>
                        ) : (
                          <>
                            {cmd ? (
                              <div>
                                <div className="text-xs opacity-70 mb-2">{platformLabel(tab as Platform)} command</div>
                                {renderCopy(cmd)}
                              </div>
                            ) : (
                              <div className="text-xs opacity-70">No command for this platform.</div>
                            )}

                            {tab === 'linux' && isWin && !isLinux ? (
                              <div className="text-xs opacity-70">Windows only (shown under Linux tab filtered out by default).</div>
                            ) : null}
                          </>
                        )}
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
