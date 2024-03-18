// @flow
import type { Attachment } from './Attachment';
import type { Meta } from '../Meta';

export type FileStorageResponse = {
  attachments: Array<Attachment>,
  meta: Meta,
};
