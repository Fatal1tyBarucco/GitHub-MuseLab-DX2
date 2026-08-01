import { LightningElement, api } from 'lwc';

export default class SmartHome extends LightningElement {
    @api demoMode = true;
    @api tabIcons = false;

    get lightsTabLabel() {
        return this.tabIcons ? '💡 Lights' : 'Lights';
    }

    get locksTabLabel() {
        return this.tabIcons ? '🔓 Locks' : 'Locks';
    }

    get tempTabLabel() {
        return this.tabIcons ? '❄️ Temp' : 'Temp';
    }

    get alarmTabLabel() {
        return this.tabIcons ? '🛡️ Alarm' : 'Alarm';
    }
}
