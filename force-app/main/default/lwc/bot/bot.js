import { LightningElement, track } from 'lwc';
import submit from '@salesforce/apex/BotController.submit';

export default class Bot extends LightningElement {
    @track messages = [];
    question = '';
    session = null;
    files = [];

    get messageList() {
        return this.messages || [];
    }

    handleKeyPress(event) {
        if (event.keyCode !== 13) return;

        const utterance = event.target.value;
        if (!utterance.trim()) return;

        this.messages = [...this.messages, { author: 'Me', messageText: utterance }];
        event.target.value = '';

        this.submitMessage(utterance, null, null);
    }

    handlePostbackClick(event) {
        const utterance = event.target.label;
        this.messages = [...this.messages, { author: 'Me', messageText: utterance }];
        this.submitMessage(utterance, null, null);
    }

    handleFileUpload(event) {
        const files = event.target.files;
        if (!files || files.length === 0) return;

        const file = files[0];
        if (!file.type.match(/(image.*)/)) {
            alert('Image file not supported');
            return;
        }

        const reader = new FileReader();
        reader.onloadend = () => {
            const dataURL = reader.result;
            const content = dataURL.match(/,(.*)$/)[1];
            const utterance = this.template.querySelector('.utterance-input')?.value || '';

            this.messages = [...this.messages, {
                author: 'Me',
                messageText: `Uploading file ${file.name}`,
                imageURL: dataURL
            }];

            this.submitMessage(utterance, file.name, content);
        };
        reader.readAsDataURL(file);
    }

    submitMessage(utterance, fileName, fileContent) {
        submit({
            utterance: utterance,
            session: this.session,
            fileName: fileName,
            fileContent: fileContent
        })
        .then(answer => {
            if (answer) {
                this.session = answer.session;
                this.messages = [...this.messages, ...answer.messages];
            }
        })
        .catch(error => {
            console.error('Bot error:', error);
            const errorMessage = error?.body?.message || error?.message || 'Unknown error';
            this.messages = [...this.messages, {
                author: 'Bot',
                messageText: `Oops, something went wrong: ${errorMessage}`
            }];
        });
    }
}
