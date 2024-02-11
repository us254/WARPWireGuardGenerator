1. Update the package list:

    ```shell
    sudo apt-get update
    ```

2. Install Git and Unrar:

    ```shell
    sudo apt-get install git unrar
    ```

3. Clone the WARPWireGuardGenerator repository:

    ```shell
    git clone https://github.com/us254/WARPWireGuardGenerator.git
    ```

4. Navigate to the cloned directory:

    ```shell
    cd WARPWireGuardGenerator
    ```

5. Install Python 3.8, venv, and dev tools:

    ```shell
    sudo apt-get install python3.8 python3.8-venv python3.8-dev
    ```

6. Create a Python virtual environment:

    ```shell
    python3.8 -m venv venv
    ```

7. Activate the virtual environment:

    ```shell
    source venv/bin/activate
    ```

8. Install required Python packages:

    ```shell
    pip install requests httpx
    ```

9. Run the warp-key-generator.py script:

    ```shell
    python warp-key-generator.py
    ```

10. Deactivate the virtual environment:

    ```shell
    deactivate
    ```

11. Extract the kk.rar file:

    ```shell
    unrar x kk.rar
    ```

12. Change directory to `kk`:

    ```shell
    cd kk
    ```

13. Make the scripts executable:

    ```shell
    chmod +x main.sh warp-go warp-api
    ```

14. Execute the main.sh script:

    ```shell
    bash ./main.sh
    ```
