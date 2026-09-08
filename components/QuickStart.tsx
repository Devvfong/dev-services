'use client'

export default function QuickStart() {
  return (
    <section className="py-16">
      <div className="container mx-auto px-6 max-w-5xl">
        <h2 className="text-2xl md:text-3xl font-bold text-center mb-10 reveal">Quick Start</h2>

        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-card border border-c rounded-xl p-6 reveal-left">
            <div className="text-lg font-semibold mb-3">1) Open PowerShell</div>
            <div className="text-m mb-4">Run as Administrator for best results.</div>
            <div className="bg-alt border border-c rounded-lg p-4 text-sm">
              <code className="break-all">Set-ExecutionPolicy Bypass -Scope Process -Force</code>
            </div>
          </div>

          <div className="bg-card border border-c rounded-xl p-6 reveal-right">
            <div className="text-lg font-semibold mb-3">2) Download & Run</div>
            <div className="text-m mb-4">Uses a standalone PowerShell bundle.</div>
            <div className="bg-alt border border-c rounded-lg p-4 text-sm">
              <code className="break-all">
                irm https://raw.githubusercontent.com/Devvfong/dev-services/master/dist/DevServices.standalone.ps1 | iex
              </code>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
