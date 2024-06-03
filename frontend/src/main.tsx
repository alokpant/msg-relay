import './index.css';
import App from './App';
import { BrowserRouter } from "react-router-dom";
import Stack from '@mui/material/Stack';
import { createRoot } from 'react-dom/client';

const container = document.getElementById('root');
const root = createRoot(container!);
root.render(<BrowserRouter>
  <Stack spacing={2} sx={{
      width: '100%',
    }}>
      <App />
    </Stack>    
  </BrowserRouter>
);