import { useState } from 'react';
import AddCommentIcon from '@mui/icons-material/AddComment';
import { Button, Dialog, DialogActions, DialogContent, DialogTitle, TextField } from '@mui/material';
import BaseAlert from '../../Alert/BaseAlert';

interface CreateMessageProps {
  setRefetchMessages: React.Dispatch<React.SetStateAction<boolean>>
  token: string
}

const CreateMessage: React.FC<CreateMessageProps> = ({ setRefetchMessages, token }) => {
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

  console.log(alert);

  return (
    <>
      <Button 
        variant="contained"
        startIcon={<AddCommentIcon />}
        color="secondary"
        sx={{
          width: "220px",
          // parent is stacked, so it has display: flex
          alignSelf: 'flex-end'
        }}
        onClick={handleClickOpen}
      >
        Add new message
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
            const { title, message } = Object.fromEntries((formData).entries());

            const response = await fetch('http://localhost:3000/messages', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
                'Authorization': token
              },
              body: JSON.stringify(
                { message: { title, body: message }
              }),
            });
            if (!response.ok) {
              return response.text().then(text => {
                setOpenAlertMessage((JSON.parse(text) as Record<'error', 'string'>)?.error)
                setAlert('warning');
              });
            } else {
              setOpenAlertMessage('Message has been successfully created')
              setAlert('success');
              setRefetchMessages(true);
              handleClose();
            }
          },
        }}
      >
        <DialogTitle  sx={{ m: 0, p: 2 }}>Create new message</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            required
            margin="dense"
            id="title"
            name="title"
            label="Title of message"
            type="text"
            fullWidth
            variant="standard"
          />

          <TextField
            required
            margin="dense"
            id="message"
            name="message"
            label="Add message"
            type="text"
            fullWidth
            variant="standard"
            multiline
            rows={2}
            maxRows={4}
          />
        
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button type="submit"
            variant="contained"
            color="secondary"
          >Create</Button>
        </DialogActions>
      </Dialog>

      { !!alert && <BaseAlert message={openAlertMessage} severity={alert} /> }
    </>
  );
}

export default CreateMessage;
