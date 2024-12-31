import React, { useState } from "react";
import { token } from "../../../declarations/token/index";
import { Principal } from "@dfinity/principal";

function Transfer() {
  const [isDisabled, setDisabled] = useState(false);
  const [reciepientId, setId] = useState("");
  const [amount, setAmount] = useState("");
  const [feedback, setFeedback] = useState("");
  const [isHidden, setHidden] = useState(true);

  async function handleClick() {
    setHidden(false);
    setDisabled(true);
    const reciepient = Principal.fromText(reciepientId); // converting the recienpient id to Principal datatype
    const amounttoTransfer = Number(amount); // converting amount from Text to Nat
    const result = await token.transfer(reciepient, amounttoTransfer);
    setFeedback(result);
    setHidden(false);
    setDisabled(false);
  }

  return (
    <div className="window white">
      <div className="transfer">
        <fieldset>
          <legend>To Account:</legend>
          <ul>
            <li>
              <input
                type="text"
                id="transfer-to-id"
                value={reciepientId}
                onChange={(e) => setId(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <fieldset>
          <legend>Amount:</legend>
          <ul>
            <li>
              <input
                type="number"
                id="amount"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
              />
            </li>
          </ul>
        </fieldset>
        <p className="trade-buttons">
          <button id="btn-transfer" disabled={isDisabled} onClick={handleClick} >
            Transfer
          </button>
        </p>
        <p hidden={isHidden}>{feedback}</p>
      </div>
    </div>
  );
}

export default Transfer;
