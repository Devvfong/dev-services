'use client'

import { useEffect, useMemo, useState } from 'react'
import { CATEGORIES, type Platform, type Tool } from '../lib/tools-data'

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
  const [selectedCat, setSelectedCat] = useState<number | 'all'>('all')
  const [copied, setCopied] = useState<string | null>(null)
  // Per-card active OS tab (for cross-platform tools)
  const [toolOsTab, setToolOsTab] = useState<Record<string, Platform>>({})

  useEffect(() => {
    if (!copied) return
    const t = window.setTimeout(() => setCopied(null), 1400)
    return () => window.clearTimeout(t)
  }, [copied])

  const filteredCategories = useMemo(() => {
    const query = q.trim().toLowerCase()

    return CATEGORIES.map((c) => {
      // Category filter
      if (selectedCat !== 'all' && c.id !== selectedCat) {
        return { ...c, tools: [] }
      }

      // Platform filter
      let tools = c.tools.filter((t) => matchesPlatform(t.platforms, tab))

      // Search filter
      if (query) {
        tools = tools.filter((t) => {
          const hay = [t.name, t.desc, c.title, t.stable, t.latest, t.cmdWin || '', t.cmdLinux || '']
            .join(' ')
            .toLowerCase()
          return hay.includes(query)
        })
      }

      return { ...c, tools }
    }).filter((c) => c.tools.length > 0)
  }, [q, tab, selectedCat])

  const totalFilteredTools = useMemo(() => {
    return filteredCategories.reduce((acc, c) => acc + c.tools.length, 0)
  }, [filteredCategories])

  function copyCmd(toolId: string, cmd: string) {
    navigator.clipboard
      .writeText(cmd)
      .then(() => setCopied(toolId))
      .catch(() => setCopied(null))
  }

  function ToolCard({ tool, categoryTitle }: { tool: Tool; categoryTitle: string }) {
    const hasWin = tool.platforms.includes('win') && !!tool.cmdWin
    const hasLinux = tool.platforms.includes('linux') && !!tool.cmdLinux
    const isMultiPlatform = hasWin && hasLinux

    // Determine which OS command to show for this card
    let activeOs: Platform = 'win'
    if (tab === 'linux') {
      activeOs = 'linux'
    } else if (tab === 'win') {
      activeOs = 'win'
    } else {
      activeOs = toolOsTab[tool.id] || (hasWin ? 'win' : 'linux')
    }

    const currentCmd = activeOs === 'win' ? tool.cmdWin : tool.cmdLinux
    const prompt = activeOs === 'win' ? 'PS>' : '$'

    return (
      <div className="tool-card flex flex-col justify-between h-full">
        {/* Mini Terminal Header */}
        <div className="mini-term-head">
          <div className="mini-term-dots" aria-hidden="true">
            <span className="mini-dot" style={{ background: '#ff5f57' }} />
            <span className="mini-dot" style={{ background: '#febc2e' }} />
            <span className="mini-dot" style={{ background: '#28c840' }} />
          </div>

          <div className="mini-term-title font-mono">{tool.name}</div>

          <div className="ml-auto flex items-center gap-1.5 shrink-0">
            {tool.platforms.map((p) => (
              <span key={p} className="platform-pill" title={`${platformName(p)} supported`}>
                {platformIcon(p)}
              </span>
            ))}
          </div>
        </div>

        {/* Mini Terminal Body */}
        <div className="mini-term-body flex-1 flex flex-col justify-between">
          <div>
            {/* Version Pills */}
            <div className="flex flex-wrap items-center gap-2 mb-3">
              <span className="pill pill-stable" title="Stable / LTS release">
                <span className="pill-dot" style={{ background: 'var(--green)' }} />
                <span>stable {tool.stable}</span>
              </span>
              <span className="pill pill-latest" title="Latest release">
                <span className="pill-dot" style={{ background: 'var(--cyan)' }} />
                <span>latest {tool.latest}</span>
              </span>
            </div>

            {/* Description */}
            <p className="text-m text-xs md:text-sm leading-relaxed mb-4 opacity-90">{tool.desc}</p>
          </div>

          {/* Command Prompt Box */}
          <div className="mt-auto">
            {/* Multi-OS switcher inside card if both OS available and tab is 'all' */}
            {isMultiPlatform && tab === 'all' && (
              <div className="flex items-center gap-1 mb-1.5">
                <button
                  type="button"
                  onClick={() => setToolOsTab((prev) => ({ ...prev, [tool.id]: 'win' }))}
                  className={`text-[11px] px-2 py-0.5 rounded transition ${
                    activeOs === 'win'
                      ? 'bg-neutral-800 text-cyan-400 font-semibold border border-neutral-700'
                      : 'text-neutral-400 hover:text-neutral-200'
                  }`}
                >
                  🪟 PowerShell
                </button>
                <button
                  type="button"
                  onClick={() => setToolOsTab((prev) => ({ ...prev, [tool.id]: 'linux' }))}
                  className={`text-[11px] px-2 py-0.5 rounded transition ${
                    activeOs === 'linux'
                      ? 'bg-neutral-800 text-cyan-400 font-semibold border border-neutral-700'
                      : 'text-neutral-400 hover:text-neutral-200'
                  }`}
                >
                  🐧 Linux / Bash
                </button>
              </div>
            )}

            {currentCmd ? (
              <div className="cmd-box">
                <div className="flex items-start justify-between gap-2">
                  <div className="min-w-0 flex-1">
                    <div className="text-[10px] text-m opacity-60 mb-1 font-mono">
                      {platformName(activeOs)} command
                    </div>
                    <code className="block text-[11px] md:text-xs break-all leading-snug font-mono text-neutral-200">
                      <span className="text-cyan-400 select-none mr-1.5 font-bold">{prompt}</span>
                      {currentCmd}
                    </code>
                  </div>
                  <div className="shrink-0 pt-0.5">
                    <button
                      type="button"
                      className="copy-btn"
                      onClick={() => copyCmd(tool.id, currentCmd)}
                      aria-label={`Copy command for ${tool.name}`}
                    >
                      {copied === tool.id ? (
                        <span className="text-green-400 font-bold">✓ Copied</span>
                      ) : (
                        'Copy'
                      )}
                    </button>
                  </div>
                </div>
              </div>
            ) : (
              <div className="text-xs text-m opacity-60 italic py-2">
                {tool.note || 'No command available for this platform.'}
              </div>
            )}
          </div>
        </div>
      </div>
    )
  }

  return (
    <section className="px-4 md:px-6 py-16" id="catalog">
      <div className="container mx-auto max-w-7xl">
        {/* Section Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-8 reveal">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-mono bg-card border border-c text-cyan mb-3">
              <span>●</span> {CATEGORIES.length} Categories · 39+ Developer Tools
            </div>
            <h2 className="text-2xl md:text-4xl font-bold tracking-tight">Tool Catalog</h2>
            <p className="text-m mt-2 text-sm md:text-base max-w-2xl opacity-90">
              Browse runtimes, system utilities, Linux packages, network switchers, and developer tools.
              Every tool includes verified <span className="text-green font-medium">stable</span> and{' '}
              <span className="text-cyan font-medium">latest</span> versions.
            </p>
          </div>

          {/* Search Bar */}
          <div className="w-full md:w-80 lg:w-96">
            <div className="relative">
              <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-m font-mono text-sm opacity-70">
                &gt;
              </span>
              <input
                type="text"
                className="w-full pl-8 pr-16 py-2.5 rounded-lg bg-card border border-c text-sm outline-none focus:ring-2 focus:ring-cyan/30 transition placeholder:text-m/50"
                placeholder="Search tools (e.g. node, docker, nala)..."
                value={q}
                onChange={(e) => setQ(e.target.value)}
              />
              {q.trim() ? (
                <button
                  type="button"
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-m hover:text-neutral-100 bg-neutral-800/80 px-1.5 py-0.5 rounded transition"
                  onClick={() => setQ('')}
                  aria-label="Clear search"
                >
                  ✕ Clear
                </button>
              ) : null}
            </div>
          </div>
        </div>

        {/* Filter Controls Bar */}
        <div className="bg-card border border-c rounded-xl p-4 mb-10 reveal space-y-3.5">
          {/* Row 1: Platform switcher & Results count */}
          <div className="flex flex-wrap items-center justify-between gap-3">
            <div className="flex flex-wrap items-center gap-2" role="tablist" aria-label="Platform filter">
              <span className="text-xs font-semibold text-m uppercase tracking-wider mr-1">OS:</span>
              <button
                type="button"
                className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition ${
                  tab === 'all'
                    ? 'bg-neutral-800 text-cyan border-cyan/40 shadow-sm'
                    : 'bg-transparent border-c text-m hover:text-neutral-200'
                }`}
                onClick={() => setTab('all')}
              >
                All Platforms
              </button>
              <button
                type="button"
                className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition ${
                  tab === 'win'
                    ? 'bg-neutral-800 text-cyan border-cyan/40 shadow-sm'
                    : 'bg-transparent border-c text-m hover:text-neutral-200'
                }`}
                onClick={() => setTab('win')}
              >
                🪟 Windows
              </button>
              <button
                type="button"
                className={`px-3 py-1.5 rounded-lg text-xs font-medium border transition ${
                  tab === 'linux'
                    ? 'bg-neutral-800 text-cyan border-cyan/40 shadow-sm'
                    : 'bg-transparent border-c text-m hover:text-neutral-200'
                }`}
                onClick={() => setTab('linux')}
              >
                🐧 Linux &amp; Ubuntu
              </button>
            </div>

            <div className="text-xs text-m font-mono">
              Showing <span className="text-cyan font-bold">{totalFilteredTools}</span> tools
            </div>
          </div>

          {/* Row 2: Category Chips */}
          <div className="flex items-center gap-2 overflow-x-auto pt-2 border-t border-c/50 no-scrollbar pb-1">
            <span className="text-xs font-semibold text-m uppercase tracking-wider shrink-0 mr-1">
              Category:
            </span>
            <button
              type="button"
              onClick={() => setSelectedCat('all')}
              className={`shrink-0 px-2.5 py-1 rounded-md text-xs transition border ${
                selectedCat === 'all'
                  ? 'bg-neutral-800 text-white border-neutral-600 font-medium'
                  : 'bg-transparent text-m border-c/60 hover:text-neutral-200 hover:border-c'
              }`}
            >
              All Categories ({CATEGORIES.length})
            </button>
            {CATEGORIES.map((c) => {
              const count = c.tools.filter((t) => matchesPlatform(t.platforms, tab)).length
              if (count === 0 && tab !== 'all') return null

              return (
                <button
                  key={c.id}
                  type="button"
                  onClick={() => setSelectedCat(c.id)}
                  className={`shrink-0 px-2.5 py-1 rounded-md text-xs transition border ${
                    selectedCat === c.id
                      ? 'bg-neutral-800 text-white border-neutral-600 font-medium'
                      : 'bg-transparent text-m border-c/60 hover:text-neutral-200 hover:border-c'
                  }`}
                >
                  [{c.id}] {c.title.split(' ')[0]} ({count})
                </button>
              )
            })}
          </div>
        </div>

        {/* Tool Cards - Responsive Grid Layout */}
        <div className="space-y-12">
          {filteredCategories.map((cat) => (
            <div key={cat.id} className="reveal">
              {/* Category Header Bar */}
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-5 pb-3 border-b border-c">
                <div className="flex items-baseline gap-2.5">
                  <span className="text-xs font-mono font-semibold px-2 py-0.5 rounded bg-neutral-800 text-cyan border border-neutral-700">
                    #{cat.id}
                  </span>
                  <h3 className="text-lg md:text-xl font-bold tracking-tight">{cat.title}</h3>
                </div>
                <div className="flex items-center gap-3">
                  <span className="text-xs text-m opacity-80">{cat.desc}</span>
                  <span className="text-xs px-2.5 py-0.5 rounded-full bg-card border border-c text-m font-mono shrink-0">
                    {cat.tools.length} {cat.tools.length === 1 ? 'tool' : 'tools'}
                  </span>
                </div>
              </div>

              {/* 3-Column Responsive Grid */}
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                {cat.tools.map((tool) => (
                  <ToolCard key={tool.id} tool={tool} categoryTitle={cat.title} />
                ))}
              </div>
            </div>
          ))}
        </div>

        {/* Empty Search Result State */}
        {filteredCategories.length === 0 ? (
          <div className="py-16 text-center bg-card border border-c rounded-2xl p-8 reveal max-w-lg mx-auto">
            <div className="text-3xl mb-3">🔍</div>
            <h4 className="text-lg font-semibold mb-1">No matching tools found</h4>
            <p className="text-sm text-m mb-4">
              We couldn&apos;t find any tool matching &ldquo;{q}&rdquo; with the selected filters.
            </p>
            <button
              type="button"
              onClick={() => {
                setQ('')
                setTab('all')
                setSelectedCat('all')
              }}
              className="btn-p px-4 py-2 rounded-lg text-xs font-semibold"
            >
              Reset All Filters
            </button>
          </div>
        ) : null}
      </div>
    </section>
  )
}
