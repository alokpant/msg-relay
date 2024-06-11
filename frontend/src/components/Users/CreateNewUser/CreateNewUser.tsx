import { useState } from 'react';
import PersonAddAltIcon from '@mui/icons-material/PersonAddAlt';
import { Button, Dialog, DialogActions, DialogContent, DialogTitle, TextField } from '@mui/material';
import BaseAlert from '../../Alert/BaseAlert';

interface CreateUserProps {
  setRefetchUsers: React.Dispatch<React.SetStateAction<boolean>>
}

const CreateNewUser: React.FC<CreateUserProps> = ({ setRefetchUsers }) => {
  const [open, setOpen] = useState(false);
  const [alert, setAlert] = useState<'success' | 'warning' | undefined>();
  const [openAlertMessage, setOpenAlertMessage] = useState('');

  const handleClickOpen = () => {
    setAlert(undefined);
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <>
      <Button 
        variant="contained"
        startIcon={<PersonAddAltIcon />}
        color="secondary"
        sx={{
          width: "180px",
          // parent is stacked, so it has display: flex
          alignSelf: 'flex-end'
        }}
        onClick={handleClickOpen}
        data-testid="button-add-new-user"
      >
        Add new user
      </Button>
      <Dialog
        open={open}
        onClose={handleClose}
        maxWidth={'sm'}
        fullWidth={true}
        PaperProps={{
          component: 'form',
          onSubmit: async (event: React.FormEvent<HTMLFormElement>) => {
            event.preventDefault();
            setAlert(undefined);
            const formData = new FormData(event.currentTarget);
            const formJson = Object.fromEntries((formData).entries());
            const email = formJson.email

            const response = await fetch('http://localhost:3000/users', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify({ email }),
            });
            if (!response.ok) {
              return response.text().then(text => {
                setOpenAlertMessage((JSON.parse(text) as Record<'error', 'string'>)?.error)
                setAlert('warning');
              });
            } else {
              setOpenAlertMessage('User has been successfully created')
              setAlert('success');
              setRefetchUsers(true);
              handleClose();
            }
          },
        }}
      >
        <DialogTitle  sx={{ m: 0, p: 2 }}>Create new user</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            required
            margin="dense"
            id="email"
            name="email"
            label="Email Address"
            type="email"
            fullWidth
            variant="standard"
            inputProps={{ 'data-testid': "input-email" }}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose} data-testid="button-cancel-user">Cancel</Button>
          <Button type="submit"
            variant="contained"
            data-testid="button-create-user"
            color="secondary"
          >Create</Button>
        </DialogActions>
      </Dialog>

      { !!alert && <BaseAlert message={openAlertMessage} severity={alert} /> }
    </>
  );
}

export default CreateNewUser;
