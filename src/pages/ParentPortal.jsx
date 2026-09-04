import React from 'react';
import { useNavigate } from 'react-router-dom';
import Header from '../components/Header';
import Card from '../components/Card';
import { useAppContext } from '../context/AppContext';

export default function ParentPortal() {
  const navigate = useNavigate();
  const { sessionLogs } = useAppContext();

  return (
    <div style={{ backgroundColor: 'var(--color-bg-primary)', minHeight: '100vh' }}>
      <Header title="Parent Portal" />
      
      <div style={{ padding: '0 24px 24px', display: 'flex', flexDirection: 'column', gap: '20px' }}>
        <button className="btn btn-secondary btn-full" onClick={() => navigate('/child')}>
          Back to Child Game
        </button>
        
        <h2 style={{ color: 'var(--color-text-main)', marginTop: '16px' }}>Recent Sessions</h2>
        
        {sessionLogs.length === 0 ? (
          <Card><p>No sessions recorded yet.</p></Card>
        ) : (
          sessionLogs.slice().reverse().map((log, idx) => (
            <Card key={idx} style={{ padding: '16px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                <strong style={{ fontSize: '18px' }}>{log.moduleId.toUpperCase()} - Level {parseInt(log.levelId) + 1}</strong>
                <span style={{ color: log.passed ? 'var(--color-success)' : 'var(--color-error)', fontWeight: 'bold' }}>
                  {log.passed ? 'PASSED' : 'TRY AGAIN'}
                </span>
              </div>
              <p>Score: {log.score} / {log.total}</p>
              <p style={{ fontSize: '14px', color: 'var(--color-text-muted)' }}>
                {new Date(log.timestamp).toLocaleString()}
              </p>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
