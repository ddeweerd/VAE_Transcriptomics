Latent Space Arithmetics to Extracts Disease Modules
================================

## Introduction
Welcome to the github page for extracting gene modules based on signal extraction from multifactorial data. In this context, we introduce the Variational Autoencoder (VAE) method, as outlined in the work by de Weerd et al. (2023). The VAE offers a multi-scale representation capable of encoding cellular processes, encompassing factors from cell types to gene-gene interactions.

In the study by de Weerd et al., we harnessed the power of this VAE to predict gene expression changes in 25 independent disease datasets. Leveraging the learned healthy representations within the VAE, we successfully extracted and decoded disease-specific signals residing within the latent space. As a result, we achieved substantial enrichments of genes directly associated with the diseases under investigation.

## Methods
Here we present how to use our VAE model, as introduced in de Weerd et al., 2023. Moreover, we include the code for the model construction, to serve as a foundation for anyone that wants to train similar models. A VAE of class VAE_class, i.e. the same we used in de Weerd et al., can be constructed in using the Python script VAE_builder.py, building on the Keras package. Models of the VAE_class can be loaded using load_model function in the utils_VAE.py script. 

**Important:** If you want to use the model as was presented in the paper, you can use the the following [link to our Google colab jupyter notebook](https://colab.research.google.com/drive/1GwE2ShhpH8AqcKLZGuz372UJ-7o6O3tP?exids=71471476%2C71471470#scrollTo=xzoM9wLMlUwA)

Our approach can be summarized in the following four steps. First, ... 


