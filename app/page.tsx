import Header from '../components/Header'
import Hero from '../components/Hero'
import Terminal from '../components/Terminal'
import Features from '../components/Features'
import QuickStart from '../components/QuickStart'
import Footer from '../components/Footer'

export default function HomePage() {
  return (
    <div className="min-h-screen antialiased">
      <Header />
      <main>
        <Hero />
        <section className="px-6 py-8">
          <div className="max-w-5xl mx-auto">
            <Terminal />
          </div>
        </section>
        <Features />
        <QuickStart />
      </main>
      <Footer />
    </div>
  )
}
