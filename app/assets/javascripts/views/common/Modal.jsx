// @flow
import React from 'react';

type Props = {
  className?: string,
  id?: string,
  children?: any,
};

export default function Modal(props: Props) {
  const { className, id } = props;
  return (
    <div className={className} id={id}>
      <div className="modal-dialog">
        <div className="modal-content">{props.children}</div>
      </div>
    </div>
  );
}

Modal.Header = function Header(props: Props) {
  return (
    <div className="modal-header modal-group-chat__member">
      <h2 className="modal-title">{props.children}</h2>
      <button type="button" className="close" data-dismiss="modal">
        &times;
      </button>
    </div>
  );
};

Modal.Body = function Body(props: Props) {
  return <div className="modal-body">{props.children}</div>;
};
