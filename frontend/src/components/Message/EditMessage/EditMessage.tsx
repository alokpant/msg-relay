import { useState } from 'react';

import { Button, Dialog, DialogActions, DialogContent, DialogTitle, TextField } from '@mui/material';
import BaseAlert from '../../Alert/BaseAlert';

interface Message {
  title: string
  message: string
  id: string
}

interface EditMessageProps {
  setRefetchMessages: React.Dispatch<React.SetStateAction<boolean>>
  token: string
  body: Message
  open: boolean
  setOpen: React.Dispatch<React.SetStateAction<boolean>>
}

const EditMessage: React.FC<EditMessageProps> = (
  {
    setRefetchMessages,
    token,
    open,
    setOpen,
    body
  }
) => {
  const [alert, setAlert] = useState<'success' | 'warning' | undefined>();
  const [openAlertMessage, setOpenAlertMessage] = useState('');
  const { title, message, id } = body;

  const handleClose = () => {
    setOpen(false);
  };

  return (
    <>
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

            console.log('title', title)
            console.log('message', message)
            const response = await fetch(`http://localhost:3000/messages/${id}`, {
              method: 'PUT',
              headers: {
                'Content-Type': 'application/json',
                'Authorization': token
              },
              body: JSON.stringify(
                { message: { title: title, body: message }
              }),
            });
            if (!response.ok) {
              return response.text().then(text => {
                setOpenAlertMessage((JSON.parse(text) as Record<'error', 'string'>)?.error)
                setAlert('warning');
              });
            } else {
              setOpenAlertMessage('Message has been updated')
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
            defaultValue={title}
          />

          <TextField
            required
            margin="dense"
            id="message"
            name="message"
            label="Add message"
            type="text"
            defaultValue={message}
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
          >Update</Button>
        </DialogActions>
      </Dialog>

      { !!alert && <BaseAlert message={openAlertMessage} severity={alert} /> }
    </>
  );
}

export default EditMessage;
