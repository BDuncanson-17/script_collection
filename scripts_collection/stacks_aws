import argparse
import boto3
import time


def get_all_stack_names():
    cf_client = boto3.client('cloudformation')
    response = cf_client.list_stacks(StackStatusFilter=['CREATE_COMPLETE', 'UPDATE_COMPLETE'])
    stack_names = [stack['StackName'] for stack in response['StackSummaries']]
    return stack_names


def delete_stack(stack_name):
    cf_client = boto3.client('cloudformation')
    cf_client.delete_stack(StackName=stack_name)
    print(f'Deleting stack "{stack_name}"...')

    while True:
        response = cf_client.describe_stacks(StackName=stack_name)
        stack_status = response['Stacks'][0]['StackStatus']

        if stack_status in ['DELETE_COMPLETE', 'DELETE_FAILED']:
            break

        time.sleep(5)

    print(f'Stack "{stack_name}" deleted successfully.')


def delete_all_stacks():
    stack_names = get_all_stack_names()
    for stack_name in stack_names:
        delete_stack(stack_name)


def main():
    parser = argparse.ArgumentParser(description='AWS CloudFormation stack management script')
    parser.add_argument('-l', '--list_all', action='store_true', help='List all stack names')
    parser.add_argument('-d', '--delete_stack', type=int, help='Delete stack by index')
    parser.add_argument('-da', '--delete_all', action='store_true', help='Delete all stacks')
    args = parser.parse_args()

    if args.list_all:
        print_stack_names()

    if args.delete_stack:
        stack_names = get_all_stack_names()
        stack_index = args.delete_stack - 1

        if 0 <= stack_index < len(stack_names):
            stack_name = stack_names[stack_index]
            delete_stack(stack_name)
        else:
            print('Invalid stack index.')

    if args.delete_all:
        delete_all_stacks()


if __name__ == '__main__':
    main()
