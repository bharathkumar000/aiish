const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5001/api';

/**
 * Fetch current therapist configuration
 */
export async function getTherapistConfig() {
  try {
    const res = await fetch(`${API_BASE_URL}/config`);
    if (!res.ok) throw new Error('Failed to fetch config');
    return await res.json();
  } catch (err) {
    console.warn('Backend unavailable, using local defaults:', err.message);
    return null;
  }
}

/**
 * Save updated therapist configuration
 */
export async function updateTherapistConfig(config) {
  try {
    const res = await fetch(`${API_BASE_URL}/config`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(config),
    });
    return await res.json();
  } catch (err) {
    console.error('Failed to update config on backend:', err.message);
    return null;
  }
}

/**
 * Log a completed training session
 */
export async function logSession(sessionData) {
  try {
    const res = await fetch(`${API_BASE_URL}/sessions`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(sessionData),
    });
    return await res.json();
  } catch (err) {
    console.error('Failed to log session to backend:', err.message);
    return null;
  }
}

/**
 * Fetch session history & analytics for therapist/parent
 */
export async function getSessions(childId = 'default') {
  try {
    const res = await fetch(`${API_BASE_URL}/sessions?childId=${childId}`);
    if (!res.ok) throw new Error('Failed to fetch sessions');
    return await res.json();
  } catch (err) {
    console.warn('Backend unavailable, returning empty session list:', err.message);
    return [];
  }
}
