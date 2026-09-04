import './globals.css';
import { AppProvider } from '@/context/AppContext';

export const metadata = {
  title: 'Auditory Closure Training',
  description: 'An interactive gamified training app for children',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        <div className="app-container">
          <AppProvider>
            {children}
          </AppProvider>
        </div>
      </body>
    </html>
  );
}
