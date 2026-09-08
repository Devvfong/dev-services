'use client'

export default function QuickStart() {
  const winCmd = 'Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/Devvfong/dev-services/master/dist/DevServices.standalone.ps1 | iex'
  const linuxCmd = 'bash <(curl -fsSL https://raw.githubusercontent.com/Devvfong/dev-services/master/dist/DevServices.linux.sh)'

  return (
    <section className="py-16">
      <div className="container mx-auto px-6 max-w-5xl">
        <h2 className="text-2xl md:text-3xl font-bold text-center mb-10 reveal">Quick Start</h2>

        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-card border border-c rounded-xl p-6 reveal-left">
            <div className="text-lg font-semibold mb-3">🪟 Windows — PowerShell</div>
            <div className="text-m mb-4">Run as Administrator for best results.</div>
            <div className="bg-alt border border-c rounded-lg p-4 text-sm">
              <code className="break-all">{winCmd}</code>
            </div>
          </div>

          <div className="bg-card border border-c rounded-xl p-6 reveal-right">
            <div className="text-lg font-semibold mb-3">🐧 Linux / Ubuntu — Terminal</div>
            <div className="text-m mb-4">Works with Bash on Ubuntu/Debian-based distros.</div>
            <div className="bg-alt border border-c rounded-lg p-4 text-sm">
              <code className="break-all">{linuxCmd}</code>
            </div>
          </div>
        </div>

        <div className="mt-6 bg-card border border-c rounded-xl p-6 reveal">
          <div className="text-lg font-semibold mb-3">Browse the full catalog</div>
          <p className="text-m mb-4">
            Search every tool below by name, category, or version. Switch between Windows and Linux/Ubuntu views.
          </p>
        </div>
      </div>
    </section>
  )
}
