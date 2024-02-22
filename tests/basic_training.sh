cat /mloscratch/homes/solergib/transformers-in-rcp/tests/basic_training.sh

export PYTHONPATH=/mloscratch/homes/solergib/transformers-in-rcp/src:$PYTHONPATH 
export PYTHON_FILE="/mloscratch/homes/solergib/transformers-in-rcp/src/training.py"

ngpusList=1
batchsizeList=64,128,256
learningRates=5e-5,1e-4,5e-4

  for lr in ${learningRates//,/ }
do
  for bs in ${batchsizeList//,/ }
do 
  for n_gpu in ${ngpusList//,/ }
do
    export PYTHON_ARGS=" \ 
        --mixed_precision fp16 \ 
        --batch_size $bs \
        --eval_batch_size 512 \
        --num_epochs 3 \
        --model_name distilbert-base-uncased \
        --learning_rate $lr \
        --dataset emotion \
        "
    torchrun --nproc_per_node $n_gpu $PYTHON_FILE $PYTHON_ARGS
done
done
done