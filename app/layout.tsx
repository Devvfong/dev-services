import './globals.css'
import { JetBrains_Mono } from 'next/font/google'
import type { Metadata, Viewport } from 'next'

const mono = JetBrains_Mono({ subsets: ['latin'], weight: ['300','400','500','600','700'] })

export const metadata: Metadata = {
  title: 'DevServices — Windows Developer & System Suite',
  description: 'DevServices - Ultimate Windows Developer & System Maintenance Suite',
}

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1.0,
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" data-theme="dark" className={mono.className}>
      <body>{children}</body>
    </html>
  )
}
