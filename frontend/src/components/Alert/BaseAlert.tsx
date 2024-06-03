import CheckIcon from '@mui/icons-material/Check';
import { Alert, AlertColor, AlertPropsColorOverrides, Fade, Snackbar } from '@mui/material';
import { OverridableStringUnion } from '@mui/types';
import { useState } from 'react';

export interface AlertProps {
  message: string
  severity: OverridableStringUnion<AlertColor, AlertPropsColorOverrides>
}

const BaseAlert: React.FC<AlertProps> = ({ severity, message }) => {
  const [open, setOpen] = useState(true);
  
  return (
    <Fade
      in={open}
      timeout={{ enter: 1000, exit: 3000 }}
      addEndListener={() => {
        setTimeout(() => {
          setOpen(false)
        }, 1000);
      }}
    >
      <Snackbar open={open}>
        <Alert
          icon={<CheckIcon fontSize="inherit" />}
          variant="filled" severity={severity || 'success'}
        >
          { message }
        </Alert>
      </Snackbar>
    </Fade>
  );
}

export default BaseAlert;
