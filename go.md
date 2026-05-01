

# Download and install - The Go Programming Language

> ## Excerpt
> Download and install Go quickly with the steps described here.

---
1.  [Documentation](https://go.dev/doc/)
2.  [Download and install](https://go.dev/doc/install)
3.  [Download Url wget] (https://go.dev/dl/go1.26.2.linux-amd64.tar.gz)

Download and install Go quickly with the steps described here.

For other content on installing, you might be interested in:

-   [Managing Go installations](https://go.dev/doc/manage-install) -- How to install multiple versions and uninstall.
-   [Installing Go from source](https://go.dev/doc/install/source) -- How to check out the sources, build them on your own machine, and run them.

[Download (1.26.2)](https://go.dev/dl/)

## Go installation[¶](https://go.dev/doc/install#install)

Select the tab for your computer's operating system below, then follow its installation instructions.

1.  **Remove any previous Go installation** by deleting the /usr/local/go folder (if it exists), then extract the archive you just downloaded into /usr/local, creating a fresh Go tree in /usr/local/go:
    
    ```
          $ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.26.2.linux-amd64.tar.gz
          
        
    ```
    
    (You may need to run each command separately with the necessary permissions, as root or through `sudo`.)
    
    **Do not** untar the archive into an existing /usr/local/go tree. This is known to produce broken Go installations.
    
2.  Add /usr/local/go/bin to the `PATH` environment variable.
    
    You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):
    
    ```
              export PATH=$PATH:/usr/local/go/bin
              
            
    ```
    
    **Note:** Changes made to a profile file may not apply until the next time you log into your computer. To apply the changes immediately, just run the shell commands directly or execute them from the profile using a command such as `source $HOME/.profile`.
    
3.  Verify that you've installed Go by opening a command prompt and typing the following command:
    
    ```
              $ go version
              
            
    ```
    
4.  Confirm that the command prints the installed version of Go.
