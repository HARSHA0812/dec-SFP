import { LightningElement, track } from 'lwc';

export default class DynamicButtonWindowComponent extends LightningElement {
    @track dynamicUrl = ''; // Stores the URL input from the user
    @track showButton = true; // Controls visibility of the "Open Window" button
    @track showCompletion = false; // Controls visibility of the "Completed" modal

    openedWindow; // Reference to the opened window
    checkWindowInterval; // Interval ID for monitoring the window

    // Handle dynamic URL input changes
    handleUrlChange(event) {
        this.dynamicUrl = event.target.value; // Update the URL value in real-time
    }

    // Method to open a new window with the dynamic URL
    openWindow() {
        if (!this.dynamicUrl) {
            alert('Please enter a valid URL before proceeding.');
            return;
        }

        this.openedWindow = window.open(
            this.dynamicUrl,
            '_blank',
            'width=900,height=660,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,status=no'
        );

        // Start monitoring the new window
        this.checkWindowInterval = setInterval(() => {
            if (this.openedWindow && this.openedWindow.closed) {
                clearInterval(this.checkWindowInterval); // Stop monitoring
                this.openedWindow = null; // Reset window reference
                this.showButton = false; // Hide the "Open Window" button
                this.showCompletion = true; // Show the "Completed" modal
            }
        }, 500); // Check every 500ms
    }

    // Method to handle "Finish" button click
    handleFinish() {
        this.showCompletion = false; // Hide the "Completed" modal
        this.showButton = true; // Reset the component to its initial state
    }
}