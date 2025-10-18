## 🔐 Granting Access to Your EKS Cluster

By default, **creating an EKS cluster does not grant the creator immediate access** to interact with the cluster using `kubectl`.
EKS uses **IAM-based access control**, so you must explicitly add your IAM user or role to the cluster's access configuration.

### 🧾 Step-by-Step: Add Yourself as an EKS Admin

1. **Identify your current IAM identity**
   Run the following command in your terminal:

   ```bash
   aws sts get-caller-identity
   ```

   This will output something like:

   ```json
   {
     "UserId": "XXXXXXXXXXX",
     "Account": "123456789012",
     "Arn": "arn:aws:iam::123456789012:user/AWS_Dev_User"
   }
   ```

   Copy the value of the `Arn` field.

2. **Add access via AWS Console**

   * Go to the **Amazon EKS** console.
   * Select your cluster.
   * Navigate to the **Access** tab.
   * Click **“Create access entry”**.
   * In the **IAM principal ARN** field, paste the ARN you copied earlier.
   * Choose **Standard** as the access type.
   * Click **Next**.
   * In the **Policy** dropdown, select **Amazon EKS Cluster Admin**.
   * Click **Add policy**.
   * Click **Next**, then **Create**.

3. **Access the cluster using `kubectl`**

   Once the access entry is created, you can interact with your cluster:

   ```bash
   kubectl get nodes
   ```

🎉 You're now authenticated and authorized to manage your EKS cluster using `kubectl`!

