import ReactDOM from 'react-dom';
import React from 'react';
import App from "./components/App";
import { AuthClient } from "@dfinity/auth-client";

const init = async () => {
  const authClient = await AuthClient.create();

  if (await authClient.isAuthenticated()) {
    handleAuthenticated();
  } else {
    await authClient.login({
      identityProvider: "https://identity.ic0.app/#authorize", // Login frontend
      onSuccess: () => {
        handleAuthenticated();
      },
    });
  }

  async function handleAuthenticated() {
    ReactDOM.render(<App />, document.getElementById("root")); // Render the app after authentication
  }
};

// Call the init function once to start the authentication process
init();
