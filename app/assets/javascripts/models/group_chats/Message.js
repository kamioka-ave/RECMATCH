// @flow
export type Message = {
  id?: number,
  body: string,
  attachment?: string | Blob | File,
  senderId: number,
  senderType: string,
  groupChatId: number,
  metaData?: Object,
  senderName?: string,
  name: string,
  companyId: number,
  companyName: string,
};


export function link(message: Message, memberType: string, memberId: number): string {
  if (memberType === "Supporter") {
    return "/mypage/supporter/companies/" + message.companyId + "/group_chat_categories/" + message.groupChatCategoryId;
  }
  return `/mypage/${memberType.toLocaleLowerCase()}/group_chat_categories/${message.groupChatCategoryId}`;
}

export function content(message: Message, memberType: string, memberId: number): string {
  const isMention = message.body.indexOf(`TO id:${memberId} type:${memberType}`) != -1;
  const mentionMessage = "であなたにメッセージを送信しました。";
  const normalMessage = "でメッセージを送信しました。";

  if ((memberType === "Company" || memberType === "Staff") && isMention) {
    return `${message.senderName}さんが${message.groupChatName}${mentionMessage}`;
  } else if (memberType === "Company" || memberType === "Staff") {
    return `${message.senderName}さんが${message.groupChatName}${normalMessage}`;
  } else if (memberType === "Supporter" && isMention) {
    return `${message.senderName}さんが${message.companyName}の${message.groupChatName}${mentionMessage}`;
  }
  return `${message.senderName}さんが${message.companyName}の${message.groupChatName}${normalMessage}`;
}
