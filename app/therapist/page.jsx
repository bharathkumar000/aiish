"use client";
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import Header from '../../src/components/Header';
import Card from '../../src/components/Card';
import Button from '../../src/components/Button';
import { useAppContext } from '../../src/context/AppContext';

export default function TherapistPortal() {
  const router = useRouter();
  const { therapistConfig, updateConfig, sessionLogs, resetProgress } = useAppContext();
  
  const [threshold, setThreshold] = useState(therapistConfig.passThreshold);

  const handleSave = () => {
    updateConfig({ passThreshold: parseInt(threshold) });
    alert('Configuration Saved!');
  };

  const handleReset = () => {
    if (window.confirm("Are you sure you want to reset all child progress and logs?")) {
      resetProgress();
    }
  };

  return (
    <div style={{ backgroundColor: 'var(--color-bg-primary)', minHeight: '100vh' }}>
      <Header title="Therapist Portal" />
      
      <div style={{ padding: '0 24px 24px', display: 'flex', flexDirection: 'column', gap: '20px' }}>
        <button className="btn btn-secondary btn-full" onClick={() => router.push('/child/dashboard')}>
          Back to Child Game
        </button>
        
        <Card style={{ marginTop: '16px' }}>
          <h3 style={{ marginBottom: '16px' }}>Clinical Configuration</h3>
          <label style={{ display: 'block', fontWeight: 'bold', marginBottom: '8px' }}>
            Pass Threshold (%) to Unlock Next Level
          </label>
          <input 
            type="number" 
            value={threshold} 
            onChange={(e) => setThreshold(e.target.value)}
            style={{ 
              width: '100%', padding: '12px', borderRadius: '12px', 
              border: '3px solid #4A4036', fontSize: '16px', marginBottom: '16px'
            }}
          />
          <Button fullWidth onClick={handleSave}>Save Settings</Button>
        </Card>

        <Card>
          <h3 style={{ marginBottom: '16px' }}>Detailed Clinical Logs</h3>
          <p style={{ fontSize: '14px', marginBottom: '16px' }}>Total Sessions: {sessionLogs.length}</p>
          
          <div style={{ maxHeight: '300px', overflowY: 'auto', backgroundColor: '#f3f4f6', padding: '8px', borderRadius: '8px', border: '2px solid #ccc' }}>
            <pre style={{ fontSize: '12px', margin: 0 }}>
              {JSON.stringify(sessionLogs, null, 2)}
            </pre>
          </div>
          
          <Button fullWidth onClick={handleReset} style={{ backgroundColor: '#ef4444', color: 'white', marginTop: '16px', border: 'none' }}>
            RESET ALL PROGRESS
          </Button>
        </Card>

      </div>
    </div>
  );
}
